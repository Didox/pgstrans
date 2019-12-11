class ContaCorrente < ApplicationRecord
  belongs_to :usuario
  belongs_to :lancamento
  belongs_to :banco

  after_save :atualiza_saldo

  private

  def atualiza_saldo
  	ContaCorrente.where(id: self.id).update_all(data_ultima_atualizacao_saldo: Time.zone.now, saldo_atual: ContaCorrente.where(usuario_id: usuario).sum(:valor))
  end
end
