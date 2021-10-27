class ApplicationController < ActionController::Base
  before_action :validate_login

  def usuario_logado
    administrador
  end

  def administrador
    if @adm.present? || cookies[:usuario_pgstrans_oauth].present?
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
      if request.path_parameters[:format] == 'json'
        authorization = request.headers['Authorization']
        bearer, token = authorization.split(" ")
        if bearer.to_s.downcase == "bearer" && token.present?
          begin
            usuario, algoritmo = JWT.decode(token, SECRET_JWT, true, { algorithm: 'HS256' })
            @adm = Usuario.find(usuario["id"])
          rescue;end
        end
      end

      if @adm.blank?
        if cookies[:usuario_pgstrans_oauth].blank? || cookies[:usuario_pgstrans_oauth_time].blank?
          flash[:error] = "Área restrita. Digite o login e palavra-passe para entrar."

          if self.class.to_s == "RecargaController" 
            render json: {mensagem: "Área restrita. Digite o login e palavra-passe para entrar."}, status: 401
            return
          end

          redirect_to login_path
        else
          time = cookies[:usuario_pgstrans_oauth_time].to_time + 5.seconds

          cookies[:usuario_pgstrans_oauth] = { 
            value: cookies[:usuario_pgstrans_oauth], 
            expires: time, 
            httponly: true
          }

          cookies[:usuario_pgstrans_oauth_time] = { 
            value: time, 
            expires: time, 
            httponly: true 
          }
        end
      end

      if administrador.present?
        Log.responsavel_log = administrador.nome

	      return true if self.class.to_s == "WelcomeController" || self.class.to_s == "GrupoUsuariosController"

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
