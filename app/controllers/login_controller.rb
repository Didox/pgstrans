class LoginController < ApplicationController
  layout = "login"
  skip_before_action :verify_authenticity_token, only: [:autentica, :mudar_senha, :password_esquecida, :recuperar_password_esquecida]
  skip_before_action :validate_login

  def index;end
  def autentica
    if params[:email].present? && params[:senha].present?
      senha = Digest::SHA1.hexdigest(params[:senha])
      usuarios = Usuario.ativo.where("email = ? or login = ?", params[:email], params[:email]).where(senha: senha, status_cliente_id: StatusCliente.where("lower(nome) = 'ativo'"))
      if usuarios.count > 0
        usuario = usuarios.first
        Usuario.where(id: usuario.id).update_all(logado: true)
        time = params[:remember].present? ? 1.year.from_now : 30.minutes.from_now
        cookies[:usuario_pgstrans_oauth] = { 
          value: {
            id: usuario.id,
            nome: usuario.nome,
            email: usuario.email,
          }.to_json, 
          expires: time, 
          httponly: true 
        }
        UsuarioAcesso.create(usuario: usuario, mac_adress: request.ip)
        redirect_to root_path
        return
      end
    end

    flash[:error] = "E-mail ou senha inválidos"
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

    usuarioToken = TokenUsuarioSenha.where(token: params[:token]).where("created_at > ?", Time.zone.now - 60.minutes).first
    if usuarioToken.blank?
      flash[:error] = "Token de recuperação inválido"
      redirect_to login_path
      return
    end

    @usuario = usuarioToken.usuario

    require 'securerandom'
    @token = SecureRandom.uuid
    TokenUsuarioSenha.where(usuario_id: @usuario.id).destroy_all
    TokenUsuarioSenha.create(usuario_id: @usuario.id, token: @token)
  end

  def password_esquecida;end
  def recuperar_password_esquecida
    if params[:email].blank?
      flash[:error] = "E-mail não pode ficar em branco"
      redirect_to "/password-esquecida"
      return
    end

    usuario = Usuario.where(email: params[:email], status_cliente_id: StatusCliente.where("lower(nome) = 'ativo'")).first
    if usuario.present?
      flash[:notice] = "Encaminhado e-mail de recuperação. Caso não o encontre, verifique caixa de spam ou repita a operação"
      UsuarioMailer.recupera_senha(usuario).deliver
      redirect_to login_path
    else
      flash[:error] = "E-mail não cadastrado ou inativo"
      redirect_to "/password-esquecida"
    end
  end
  
  def mudar_senha
    if params[:token].blank?
      flash[:error] = "Token não pode ficar em branco"
      redirect_to login_path
      return
    end

    usuarioToken = TokenUsuarioSenha.where(token: params[:token]).first
    if usuarioToken.blank?
      flash[:error] = "Token de recuperação inválido"
      redirect_to login_path
      return
    end

    usuario = usuarioToken.usuario
    require 'securerandom'
    @token = SecureRandom.uuid
    TokenUsuarioSenha.where(usuario_id: usuario.id).destroy_all
    TokenUsuarioSenha.create(usuario_id: usuario.id, token: @token)
    
    if params[:senha].blank? || params[:csenha].blank?
      flash[:error] = "Palavra-passe ou confirmação da palavra-passe não pode ficar em branco"
      redirect_to "/alterar-senha?token=#{@token}"
      return
    end

    if params[:senha].blank? != params[:csenha].blank?
      flash[:error] = "Palavra-passe precisa ser igual confirmação da palavra-passe"
      redirect_to "/alterar-senha?token=#{@token}"
      return
    end

    usuario.responsavel = usuario
    usuario.senha = params[:senha]
    unless usuario.save
      flash[:error] =  usuario.errors.full_messages.join(", ")
      redirect_to "/alterar-senha?token=#{@token}"
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
