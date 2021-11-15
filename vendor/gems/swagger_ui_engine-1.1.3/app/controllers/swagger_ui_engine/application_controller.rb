module SwaggerUiEngine
  class ApplicationController < ActionController::Base
    include SwaggerUiEngine::AuthConfigParser

    protect_from_forgery with: :exception
    layout false

    before_action :authenticate_admin

    protected

    def authenticate_admin
      if cookies[:usuario_pgstrans_oauth].present?
        administrador = Usuario.find(JSON.parse(cookies[:usuario_pgstrans_oauth])["id"])
        if administrador.logado
          return true if self.class.to_s == "WelcomeController" || self.class.to_s == "GrupoUsuariosController"

          if administrador.acessos.blank?
            if request.path_parameters[:format] == 'json'
              return render json: {mensagem: "Usuário sem permissão de acesso a página"}, status: 401
            end

            flash[:erro] = "Usuário sem permissão de acesso a página"
            return redirect_to "/"
          else
            unless administrador.acessos.include? "#{self.class}::#{params[:action]}"
              if request.path_parameters[:format] == 'json'
                return render json: {mensagem: "Usuário sem permissão de acesso a página"}, status: 401
              end
              
              flash[:erro] = "Usuário sem permissão de acesso a página"
              return redirect_to "/"
            end
          end
        else
          cookies[:usuario_pgstrans_oauth] = nil
          adm = nil
          return redirect_to "/login"
        end
      else
        return redirect_to "/login"
      end
    end
  end
end
