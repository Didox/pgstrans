class ErroAmigavel < ApplicationRecord
  def self.traducao(erro)
    erro_amigavel = ErroAmigavel.where("lower(de) = ?", erro.downcase).first
    return erro_amigavel ? erro_amigavel.para : erro
  end
end
