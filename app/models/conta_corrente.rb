class ContaCorrente < ApplicationRecord
  belongs_to :usuario
  belongs_to :lancamento
  belongs_to :banco

  before_validation :preenche_padrao

  after_save :atualiza_saldo

  private

  def preenche_padrao
  	self.data_alegacao_pagamento = Time.zone.now
  end

  def atualiza_saldo
  	ContaCorrente.where(id: self.id).update_all(data_ultima_atualizacao_saldo: Time.zone.now, saldo_atual: ContaCorrente.where(usuario_id: usuario).sum(:valor))
  end
end
