class Lancamento < ApplicationRecord
  include PermissionamentoDados
  validates :nome, presence: true, uniqueness: true

  default_scope { order('nome asc') }

  TRANSFERENCIA_ENTRE_USUARIOS = "Transferência conta vendedor"
  COMPRA_DE_CREDITO_OU_RECARGA = "Compra de crédito ou recarga"
  PAGAMENTO_DE_FATURA = "Pagamento de fatura"
  DEBITO = "Débito"
  CREDITO = "Crédito"

  ITENS_SISTEMA = [
    TRANSFERENCIA_ENTRE_USUARIOS,
    COMPRA_DE_CREDITO_OU_RECARGA,
    PAGAMENTO_DE_FATURA,
    DEBITO,
    CREDITO,
  ]
  
  def destroy
    unless Lancamento::ITENS_SISTEMA.include?(self.nome)
      super
    end
  end
end