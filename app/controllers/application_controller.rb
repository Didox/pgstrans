class ApplicationController < ActionController::Base
  before_action :validate_login, except: [:conciliacao_proxy_pay]

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

        if request.path_parameters[:format] == 'json'
          if params[:action].include?("v2")
            render json: {
              code: "PGS_SYS_0070",
              message: "Área restrita. Digite o login e palavra-passe para entrar.",
              status: 401
            }, status: 401
          else
            render json: {mensagem: "Área restrita. Digite o login e palavra-passe para entrar."}, status: 401
          end
          return
        end

        redirect_to login_path
        return
      end
      return @adm
    end
  end

  def formata_numero_duas_casas(numero)
    helper.number_to_currency(numero.to_f, :precision => 2).downcase.gsub(/kz|\./,"").gsub(",",".")
  end

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

  private

    def validate_login
      if request.path_parameters[:format] == 'json'
        authorization = request.headers['Authorization']
        if authorization.present?
          bearer, token = authorization.split(" ")
          if bearer.to_s.downcase == "bearer" && token.present?
            begin
              usuario, algoritmo = JWT.decode(token, SECRET_JWT, true, { algorithm: 'HS256' })
              @adm = Usuario.find(usuario["id"])
            rescue;end
          end
        end
      end

      if @adm.blank?
        if cookies[:usuario_pgstrans_oauth].blank? || cookies[:usuario_pgstrans_oauth_time].blank?
          flash[:error] = "Área restrita. Digite o login e palavra-passe para entrar."

          if request.path_parameters[:format] == 'json'
            if params[:action].include?("v2")
              render json: {
              code: "PGS_SYS_0070",
              message: "Área restrita. Digite o login e palavra-passe para entrar.",
              status: 401
            }, status: 401
            else
              render json: {mensagem: "Área restrita. Digite o login e palavra-passe para entrar."}, status: 401
            end
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

      # return acesso_as_paginas

      if acesso_as_paginas
        return false unless ip_validado
      else
        return true
      end
    end

    def nao_buscavel
      params_empty = params.keys.find_all{|k| !["controller", "action"].include?(k) }.map{ |param| params[param].present? }.compact.uniq rescue [false]
      return true if params_empty.blank?
      
      if params_empty.length == 1
       return true if !params_empty.first
      end

      return false
    end

    private
      def acesso_as_paginas
        if administrador.present?
          Log.responsavel_log = administrador.nome
  
          return true if paginas_autorizadas
          
          if administrador.acessos.blank?
            if request.path_parameters[:format] == 'json'
              render json: {mensagem: "Usuário sem permissão de acesso à página"}, status: 401
              return
            end
  
            flash[:erro] = "Usuário sem permissão de acesso à página"
            redirect_to "/"
            return false
          else
            unless administrador.acessos.include? "#{self.class}::#{params[:action]}"
              if request.path_parameters[:format] == 'json'
                render json: {mensagem: "Usuário sem permissão de acesso à página"}, status: 401
                return
              end
              
              flash[:erro] = "Usuário sem permissão de acesso à página"
              redirect_to "/"
              return false
            end
          end
        end

        return true
      end
      
      def paginas_autorizadas
        self.class.to_s == "WelcomeController" || self.class.to_s == "GrupoUsuariosController"
      end

      def ip_validado
        return true if paginas_autorizadas

        if request.path_parameters[:format] == 'json'
          ip = request.remote_ip rescue ""
          if ip.present? && administrador.present?
            ips = IpApiAutorizado.where(sub_distribuidor_id: administrador.sub_distribuidor_id, ip: ip)
            if ips.count == 0
              Rails.logger.info("==============[IP Bloqueado: #{ip}]===============")
              render json: {mensagem: "IP não autorizado", ip: ip}, status: 403
              return false
            end
          end
        end

        return true
      end

    protected
      require 'will_paginate/array'

      def bloqueia_resultado_busca(active_record_registros, mensagem) 
        flash[:error] = mensagem
        active_record_registros = []
        active_record_registros = active_record_registros.paginate(page:1, per_page: 10)
        return active_record_registros
      end
end
