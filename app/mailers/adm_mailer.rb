class AdmMailer < ApplicationMailer
  def notifica_csv_processado(rel)
    @usuario = Usuario.find(rel.usuario_id)
    @rel = rel
    mail(to: @usuario.email, subject: "Dados CSV Processado")
  end

  def send_otp_token_log(otp_token_log, body)
    mail(to: otp_token_log, subject: body)
  end
end
