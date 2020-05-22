class Lancamento < ApplicationRecord
  include PermissionamentoDados
  validates :nome, presence: true, uniqueness: true
  
  def destroy
    if self.nome != "Compra de crédito ou recarga"
      super
    end
  end
end
