class Usuario < ApplicationRecord
  has_many :matrix_users
  belongs_to :perfil_usuario
  belongs_to :sub_agente
  
  validates :email, presence: true, uniqueness: true
  validates :nome, :email, presence: true

  validate :verifica_tamanho_senha
  after_validation :senha_sha1

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

  private

  def verifica_tamanho_senha
    if self.senha.length > 10
      self.errors.add(:senha, "A senha não pode ser maior que 10 caracteres")
    elsif self.senha.blank? && self.id.blank?
      self.errors.add(:senha, "A senha não pode ficar em branco")
    end
  end

  def senha_sha1
    self.senha = Digest::SHA1.hexdigest(self.senha) if self.senha.length <= 10
  end
end
