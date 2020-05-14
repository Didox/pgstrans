class Lancamento < ApplicationRecord
	validates :nome, presence: true, uniqueness: true

  def destroy
    if self.nome != "Compra de crédito"
      super
    end
  end
end
