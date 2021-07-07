class AlegacaoDePagamento < ApplicationRecord
  include PermissionamentoDados
  validates :data_deposito, :valor_deposito, :numero_talao, :comprovativo, presence: true
  belongs_to :usuario
  belongs_to :banco
  belongs_to :status_alegacao_de_pagamento

  validate :validar_duplicado

  def validar_duplicado
    alegacoes = AlegacaoDePagamento.where(
      usuario_id: self.usuario_id,
      valor_deposito: self.valor_deposito,
      numero_talao: self.numero_talao,
      status_alegacao_de_pagamento_id: StatusAlegacaoDePagamento.where("lower(nome) = ?", StatusAlegacaoDePagamento::PENDENTE.downcase).first.id
    )

    if alegacoes.count > 0
      if alegacoes.first.data_deposito.end_of_day == self.data_deposito.end_of_day
        errors.add(" ", "Pedido já cadastrado. Aguarde o processamento")
      end
    end
  end

  PROCESSADO = 1
  EM_ANALISE = 2
  PENDENTE = 3
  CANCELADO = 4
  INVALIDO = 5
  REJEITADO = 6
  
  def destroy
    self.status_alegacao_de_pagamento = StatusAlegacaoDePagamento.where("lower(nome) = ?", StatusAlegacaoDePagamento::CANCELADO.downcase).first
    self.save!
    ContaCorrente.where(alegacao_de_pagamento_id: self.id).destroy_all
  end

  def processar(responsavel)
    status = StatusAlegacaoDePagamento.where("lower(nome) = ?", StatusAlegacaoDePagamento::PROCESSADO.downcase).first

    conta_corrente = ContaCorrente.where(alegacao_de_pagamento_id: self.id).first
    conta_corrente ||= ContaCorrente.new
    conta_corrente.valor = self.valor_deposito
    conta_corrente.usuario_id = self.usuario_id
    conta_corrente.responsavel = responsavel
    conta_corrente.lancamento = Lancamento.where(nome: Lancamento::DEPOSITO).first || Lancamento.first
    conta_corrente.responsavel_aprovacao_id = responsavel.id
    conta_corrente.banco_id = self.banco_id
    conta_corrente.observacao = "Depósito para o usuário #{self.usuario.nome} (#{self.usuario_id}). #{self.observacao}"
    conta_corrente.data_alegacao_pagamento = self.created_at
    conta_corrente.alegacao_de_pagamento_id = self.id
    conta_corrente.save!

    self.status_alegacao_de_pagamento = status
    self.save!
  end

  before_validation do
    if self.status_alegacao_de_pagamento_id.blank?
      self.status_alegacao_de_pagamento = StatusAlegacaoDePagamento.where("lower(nome) = ?", StatusAlegacaoDePagamento::PADRAO.downcase).first
    end
  end
end
