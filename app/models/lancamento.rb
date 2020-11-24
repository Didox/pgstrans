class Lancamento < ApplicationRecord
  include PermissionamentoDados
  validates :nome, presence: true, uniqueness: true

  TRANSFERENCIA_ENTRE_USUARIOS = "Transferência conta vendedor"
  COMPRA_DE_CREDITO_OU_RECARGA = "Compra de crédito ou recarga"
  
  def destroy
    if self.nome != Lancamento::COMPRA_DE_CREDITO_OU_RECARGA
      super
    end
  end
end
