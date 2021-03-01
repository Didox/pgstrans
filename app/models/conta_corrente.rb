class ContaCorrente < ApplicationRecord
  include PermissionamentoDados

  belongs_to :usuario
  belongs_to :lancamento, optional: true
  belongs_to :banco, optional: true

  default_scope { order(updated_at: :desc) }

  before_validation :preenche_padrao, :banco_obrigatorio, :lancamento_obrigatorio

  after_save :atualiza_saldo

  BANCO_OBRIGATORIO = [
    Lancamento::DEBITO,
    Lancamento::CREDITO
  ]

  def saldo_atual_correto
    self.saldo_anterior - self.valor
  end

  def destroy
    raise "Registro de Conta Corrente não pode ser excluído"
  end

  def self.destroy_all
    raise "Registro de Conta Corrente não pode ser excluído"
  end

  def responsavel_aprovacao
    return nil if self.responsavel_aprovacao_id.blank? 
    
    Usuario.find(self.responsavel_aprovacao_id)
  rescue
    nil
  end
  
  private

  def preenche_padrao
  	self.data_alegacao_pagamento ||= Time.zone.now
  	self.saldo_anterior ||= ContaCorrente.where(usuario_id: usuario).sum(:valor)
  end

  def banco_obrigatorio
    return if self.lancamento_id.blank?

    if BANCO_OBRIGATORIO.include?(self.lancamento.nome) && self.banco_id.blank?
      self.errors.add(:banco, "é obrigatório")
    end
  end

  def lancamento_obrigatorio
    if self.lancamento_id.blank?
      self.errors.add("Lançamento", "é obrigatório")
    end
  end

  def atualiza_saldo
  	ContaCorrente.where(id: self.id).update_all(data_ultima_atualizacao_saldo: Time.zone.now, saldo_atual: ContaCorrente.where(usuario_id: usuario).sum(:valor))
  end

  after_create do 
    Log.save_log("Inclusão de registro (#{self.class.to_s})", self.attributes)
  end

  before_update do 
    Log.save_log("Alteração de registro (#{self.class.to_s})", self.attributes)
  end

  before_destroy do 
    Log.save_log("Exclusão de registro (#{self.class.to_s})", self.attributes)
  end
end
