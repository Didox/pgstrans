class LoginController < ApplicationController
  layout = "login"
  skip_before_action :verify_authenticity_token, only: [:autentica, :autentica_api, :autentica_api_v2, :mudar_senha, :password_esquecida, :recuperar_password_esquecida]
  skip_before_action :validate_login

  def index;end
  def autentica
    #if verify_recaptcha
      if params[:email].present? && params[:senha].present?
        senha = Digest::SHA1.hexdigest(params[:senha])
        usuarios = Usuario.ativo.where("email = ? or login = ?", params[:email], params[:email]).where(senha: senha, status_cliente_id: StatusCliente.where("lower(nome) = 'ativo'"))
        if usuarios.count > 0
          usuario = usuarios.first
          Usuario.where(id: usuario.id).update_all(logado: true)
          time = params[:remember].present? ? 1.year.from_now : 30.minutes.from_now

          if usuario.senha_padrao?
            require 'securerandom'
            token = SecureRandom.uuid
            TokenUsuarioSenha.where(usuario_id: usuario.id).destroy_all
            TokenUsuarioSenha.create(usuario_id: usuario.id, token: token)
            redirect_to "/alterar-senha?token=#{token}"
            return
          end
          
          cookies[:usuario_pgstrans_oauth_time] = { 
            value: time, 
            expires: time, 
            httponly: true 
          }

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
          flash["login"] = true
          redirect_to root_path
          
          return
        end
      end

      flash[:error] = "E-mail ou palavra-passe inválidos"
      redirect_to login_path
    #else
    #  flash[:error] = "Clique na opção \"Não sou um robô\" (Captcha inválido)"
    #  redirect_to login_path
    #end
  end

  def autentica_api_v2
    autentica_apis(false)
  rescue Exception => erro

    mensagem = erro.message
    mensagem_original = mensagem
    code = "PGS_ERRO_LOGIN_0001"

    return_code = ReturnCodeApi.where("error_description ilike ?", "%#{mensagem}%").first

    if return_code.present?
      mensagem = return_code.error_description_pt 
      mensagem_original = return_code.error_description
      code = return_code.codigo_erro_pagaso
    end

    return render json: {
      code: code,
      message: mensagem,
      original_message: mensagem_original,
      status:401
    }, status: 401
  end

  def autentica_api
    autentica_apis
  rescue Exception => erro
    mensagem = erro.message
    mensagem_original = mensagem

    return_code = ReturnCodeApi.where("error_description ilike ?", "%#{mensagem}%").first

    if return_code.present?
      mensagem = return_code.error_description_pt 
      mensagem_original = return_code.error_description
    end

    return render json: {
      mensagem: mensagem, 
      original_mensagem: mensagem_original, 
      status:401
    }, status: 401
  end

  def logout
    cookies[:usuario_pgstrans_oauth] = nil
    cookies[:usuario_pgstrans_oauth_time] = nil
    redirect_to login_path
  end

  def alterar_senha
    if params[:token].blank?
      flash[:error] = "Token não pode ficar em branco"
      redirect_to login_path
      return
    end

    usuarioToken = TokenUsuarioSenha.where(token: params[:token]).where("created_at > ?", SqlDate.sql_parse(Time.zone.now - 60.minutes)).first
    if usuarioToken.blank?
      flash[:error] = "Token inválido"
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
      flash[:notice] = "Encaminhado e-mail para (re)definição de palavra-passe. Caso não o encontre, verifique caixa de spam ou repita a operação"
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
      flash[:error] = "Token inválido"
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
      flash[:error] = "Palavra-passe precisa ser igual a confirmação da palavra-passe"
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
      expires: (cookies[:usuario_pgstrans_oauth_time].to_time rescue 30.minutes.from_now), 
      httponly: true 
    }

    UsuarioAcesso.create(usuario: usuario, mac_adress: request.ip)
    redirect_to root_path
  end

  private

  def autentica_apis(v1 = true)
    if params[:email].present? && params[:senha].present?
      senha = Digest::SHA1.hexdigest(params[:senha])
      usuarios = Usuario.ativo.where("email = ? or login = ?", params[:email], params[:email]).where(senha: senha, status_cliente_id: StatusCliente.where("lower(nome) = 'ativo'"))
      if usuarios.count > 0
        usuario = usuarios.first
        Usuario.where(id: usuario.id).update_all(logado: true)

        if v1 && usuario.senha_padrao?
          require 'securerandom'
          token = SecureRandom.uuid
          TokenUsuarioSenha.where(usuario_id: usuario.id).destroy_all
          TokenUsuarioSenha.create(usuario_id: usuario.id, token: token)

          raise "Sua senha padrão precisa ser alterada, acesse o path '/alterar-senha?token=#{token}' e faça a modificação"
        end

        UsuarioAcesso.create(usuario: usuario, mac_adress: request.ip)

        payload = {
          id: usuario.id,
          nome: usuario.nome,
          updated_at: usuario.updated_at,
          senha: usuario.senha
        }

        payload[:token] = JWT.encode(payload, SECRET_JWT, 'HS256')
        return render json: payload, status: 401
      end
    end

    raise "E-mail ou palavra-passe inválidos faça a modificação"
  end
  
end
