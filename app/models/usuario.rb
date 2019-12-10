class Usuario < ApplicationRecord
  has_many :matrix_users
  belongs_to :perfil_usuario
  
  validates :email, presence: true, uniqueness: true
  validates :nome, :email, :senha, presence: true
end
