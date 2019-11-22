class CanalVenda < ApplicationRecord
  belongs_to :dispositivo
  validates :nome, presence: true, uniqueness: true
  validates :carregamento_minimo, presence: true
end
