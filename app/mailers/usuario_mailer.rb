class UsuarioMailer < ApplicationMailer
  def recupera_senha(usuario)
    @usuario = usuario
    require 'securerandom'
    @token = SecureRandom.uuid
    TokenUsuarioSenha.where(usuario_id: @usuario.id).destroy_all
    TokenUsuarioSenha.create(usuario_id: @usuario.id, token: @token)
    mail(to: @usuario.email, subject: "(Re)Definição de palavra-passe Pagasó (Pagasó Facilita Bué!)")
  end

  def notificacao_de_venda(subject, email, info)
    @info = info
    mail(to: email, subject: subject)
  end
end
