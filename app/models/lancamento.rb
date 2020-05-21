class Lancamento < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
  include PermissionamentoDados

  def destroy
    if self.nome != "Compra de crédito ou recarga"
      super
    end
  end
end
