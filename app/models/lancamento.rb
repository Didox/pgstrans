class Lancamento < ApplicationRecord
	validates :nome, presence: true, uniqueness: true

  def save!
    if self.nome == "Compra de crédito"
      raise "Este status não pode ser alterado uso interno"
    end

    super
  end

  def save
    if self.nome == "Compra de crédito"
      raise "Este status não pode ser alterado uso interno"
    end

    super
  end

  def destroy
    if self.nome != "Compra de crédito"
      super
    end
  end
end
