class AdmMailer < ApplicationMailer
  def notifica_csv_processado(rel)
    @usuario = Usuario.find(rel.usuario_id)
    @rel = rel
    mail(to: @usuario.email, subject: "Dados CSV Processado")
  end
end
