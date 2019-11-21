class Usuario < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :email, presence: true

  belongs_to :perfil_usuario
end
