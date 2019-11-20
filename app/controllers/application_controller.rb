class ApplicationController < ActionController::Base
  before_action :validate_login

  private
    def validate_login
      if cookies[:usuario_pgstrans_oauth].blank?
        flash[:error] = "Área restrita. Digite o login e senha para entrar."
        redirect_to login_path
      end
    end
end
