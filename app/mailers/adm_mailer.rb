class AdmMailer < ApplicationMailer
  def notifica_csv_processado(rel)
    @usuario = Usuario.find(rel.usuario_id)
    @rel = rel
    mail(to: @usuario.email, subject: "Dados CSV Processado")
  end

  def send_otp_token_log(otp_token_log, body)
    @otp_token_log = otp_token_log
    @body = body
    mail(to: "pagaso.facilita@gmail.com;
    rosi.volgarin@gmail.com;
    marcio.santos@tiv-tecnologia.com;
    eduardo.cavungo@tiv-tecnologia.com",
    subject: otp_token_log)
  end
end
