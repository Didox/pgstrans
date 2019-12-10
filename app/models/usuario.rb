class Usuario < ApplicationRecord
  has_many :matrix_users
  belongs_to :perfil_usuario
  belongs_to :sub_agente
  
  validates :email, presence: true, uniqueness: true
  validates :nome, :email, :senha, presence: true
end
