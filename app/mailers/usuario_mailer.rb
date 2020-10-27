class UsuarioMailer < ApplicationMailer
  def recupera_senha(usuario)
    @usuario = usuario
    require 'securerandom'
    @token = SecureRandom.uuid
    TokenUsuarioSenha.where(usuario_id: @usuario.id).destroy_all
    TokenUsuarioSenha.create(usuario_id: @usuario.id, token: @token)
    mail(to: @usuario.email, subject: "Recuperar senha Pagasó (PgsTrans)")
  end
end
