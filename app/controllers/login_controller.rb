class LoginController < ApplicationController
  layout = "login"
  skip_before_action :verify_authenticity_token, only: [:autentica]
  skip_before_action :validate_login

  def index;end
  def autentica
    if params[:email].present? && params[:senha].present?
      senha = Digest::SHA1.hexdigest(params[:senha])
      usuarios = Usuario.ativo.where("email = ? or login = ?", params[:email], params[:email]).where(senha: senha, status_cliente_id: StatusCliente.where("lower(nome) = 'ativo'"))
      if usuarios.count > 0
        usuario = usuarios.first
        Usuario.where(id: usuario.id).update_all(logado: true)
        cookies[:usuario_pgstrans_oauth] = { 
          value: {
            id: usuario.id,
            nome: usuario.nome,
            email: usuario.email,
          }.to_json, 
          expires: Time.zone.now + 1.year, 
          httponly: true 
        }
        UsuarioAcesso.create(usuario: usuario, mac_adress: request.ip)
        redirect_to root_path
        return
      end
    end

    flash[:error] = "Email ou senha inválidos"
    redirect_to login_path
  end

  def logout
    cookies[:usuario_pgstrans_oauth] = nil
    redirect_to login_path
  end

  def alterar_senha
    if params[:token].blank?
      flash[:error] = "Token não pode ficar em branco"
      redirect_to login_path
      return
    end

    usuarioToken = TokenUsuarioSenha.where(token: params[:token]).first
    if usuarioToken.present?
      flash[:error] = "Token de recuperação inválido"
      redirect_to login_path
      return
    end

    @usuario = usuarioToken.usuario

    # require 'securerandom'
    # @token = SecureRandom.uuid
    # TokenUsuarioSenha.where(usuario_id: @usuario.id).destroy_all
    # TokenUsuarioSenha.create(usuario_id: @usuario.id, token: @token)
  end

  def mudar_senha
    if params[:token].blank?
      flash[:error] = "Token não pode ficar em branco"
      redirect_to login_path
      return
    end

    usuarioToken = TokenUsuarioSenha.where(token: params[:token]).first
    if usuarioToken.present?
      flash[:error] = "Token de recuperação inválido"
      redirect_to login_path
      return
    end
    
    if params[:senha].blank? || params[:csenha].blank?
      flash[:error] = "Palavra passe ou confirmação da palavra passe não pode ficar em branco"
      redirect_to "/alterar-senha?token=#{usuarioToken.token}"
      return
    end

    if params[:senha].blank? != params[:csenha].blank?
      flash[:error] = "Palavra passe precisa ser igual confirmação da palavra passe"
      redirect_to "/alterar-senha?token=#{usuarioToken.token}"
      return
    end

    usuario = usuarioToken.usuario
    usuario.senha = params[:senha]
    unless usuario.save
      flash[:error] =  usuario.errors.inspect
      redirect_to "/alterar-senha?token=#{usuarioToken.token}"
      return
    end

    Usuario.where(id: usuario.id).update_all(logado: true)
    cookies[:usuario_pgstrans_oauth] = { 
      value: {
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
      }.to_json, 
      expires: Time.zone.now + 1.year, 
      httponly: true 
    }
    UsuarioAcesso.create(usuario: usuario, mac_adress: request.ip)
    redirect_to root_path
  end
  
end
