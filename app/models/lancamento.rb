class Lancamento < ApplicationRecord
  include PermissionamentoDados
  validates :nome, presence: true, uniqueness: true

  default_scope { order('nome asc') }

  TRANSFERENCIA_ENTRE_USUARIOS = "Transferência conta vendedor"
  COMPRA_DE_CREDITO_OU_RECARGA = "Compra de crédito ou recarga"
  DEBITO = "Débito"
  CREDITO = "Crédito"

  ITENS_SISTEMA = [
    TRANSFERENCIA_ENTRE_USUARIOS,
    COMPRA_DE_CREDITO_OU_RECARGA,
    DEBITO,
    CREDITO,
  ]
  
  def destroy
    unless Lancamento::ITENS_SISTEMA.include?(self.nome)
      super
    end
  end
end