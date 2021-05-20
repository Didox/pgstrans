class Lancamento < ApplicationRecord
  include PermissionamentoDados
  validates :nome, presence: true, uniqueness: true

  default_scope { order('nome asc') }

  TRANSFERENCIA_ENTRE_USUARIOS = "Transferência conta vendedor"
  COMPRA_DE_CREDITO_OU_RECARGA = "Compra de crédito ou recarga"
  PAGAMENTO_DE_FATURA = "Pagamento de fatura"
  ALTERACAO_PLANO = "Alteração de plano"
  ALTERACAO_PACOTE = "Alteração de pacote"
  DEBITO = "Débito"
  CREDITO = "Crédito"
  DEPOSITO = "Depósito"

  ITENS_SISTEMA = [
    TRANSFERENCIA_ENTRE_USUARIOS,
    ALTERACAO_PLANO,
    ALTERACAO_PACOTE,
    COMPRA_DE_CREDITO_OU_RECARGA,
    PAGAMENTO_DE_FATURA,
    DEBITO,
    CREDITO,
    DEPOSITO,
  ]
  
  def destroy
    unless Lancamento::ITENS_SISTEMA.include?(self.nome)
      super
    end
  end
end