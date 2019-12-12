class Usuario < ApplicationRecord
  has_many :matrix_users
  belongs_to :perfil_usuario
  belongs_to :sub_agente
  
  validates :email, presence: true, uniqueness: true
  validates :nome, :email, :senha, presence: true

  def saldo
    ContaCorrente.where(usuario_id: self.id).order("data_ultima_atualizacao_saldo desc").first.saldo_atual
  rescue
	  0
  end

  def admin?
    self.perfil_usuario.admin
  rescue
    false
  end
end
