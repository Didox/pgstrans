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
end
