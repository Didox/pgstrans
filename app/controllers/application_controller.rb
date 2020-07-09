class ApplicationController < ActionController::Base
  before_action :validate_login

  def usuario_logado
    administrador
  end

  def administrador
    if cookies[:usuario_pgstrans_oauth].present?
      return @adm if @adm.present?
      @adm = Usuario.find(JSON.parse(cookies[:usuario_pgstrans_oauth])["id"])
      unless @adm.logado
        cookies[:usuario_pgstrans_oauth] = nil
        @adm = nil
        redirect_to login_path
        return
      end
      return @adm
    end
  end

  private

    def validate_login
      if cookies[:usuario_pgstrans_oauth].blank?
        flash[:error] = "Área restrita. Digite o login e palavra-passe para entrar."

        if self.class.to_s == "RecargaController"
          render json: {mensagem: "Área restrita. Digite o login e palavra-passe para entrar."}, status: 401
          return
        end

        redirect_to login_path
      end

      if administrador.present?
	      return true if self.class.to_s == "WelcomeController"

        if administrador.acessos.blank?
          flash[:erro] = "Usuário sem permissão de acesso a página"

          if self.class.to_s == "RecargaController"
            render json: {mensagem: "Usuário sem permissão de acesso a página"}, status: 401
            return
          end

          redirect_to "/"
          return false
        else
          unless administrador.acessos.include? "#{self.class}::#{params[:action]}"
            flash[:erro] = "Usuário sem permissão de acesso a página"

            if self.class.to_s == "RecargaController"
              render json: {mensagem: "Usuário sem permissão de acesso a página"}, status: 401
              return
            end
            
            redirect_to "/"
            return false
          end
        end
      end

    end
end
