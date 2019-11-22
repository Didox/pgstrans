class Usuario < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :nome, :email, :senha, presence: true

  belongs_to :perfil_usuario
end
