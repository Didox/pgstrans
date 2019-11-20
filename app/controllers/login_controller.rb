class LoginController < ApplicationController
  layout = "login"
  skip_before_action :verify_authenticity_token, only: [:autentica]
  skip_before_action :validate_login

  def index;end
  def autentica
    if params[:email].present? && params[:senha].present?
      usuarios = Usuario.where(email: params[:email], senha: params[:senha])
      if usuarios.count > 0
        usuario = usuarios.first
        cookies[:usuario_pgstrans_oauth] = { 
          value: {
            id: usuario.id,
            nome: usuario.nome,
            email: usuario.email,
          }.to_json, 
          expires: Time.zone.now + 1.year, 
          httponly: true 
        }
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
