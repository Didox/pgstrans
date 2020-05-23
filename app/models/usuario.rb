class Usuario < ApplicationRecord
  include PermissionamentoDados
  
  has_many :matrix_users
  has_many :grupo_usuarios

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

  def acessos
    return @acessos if @acessos.present?
    @acessos = perfil_usuario.acessos_actions
  end

  def grupos
    grupo_usuarios.map{|g| g.grupo}
  end

  def grupos_id
    grupo_usuarios.map{|g| g.grupo_id}
  end

  def self.ativo
    Usuario.where(status_cliente_id: StatusCliente.where(nome: "Ativo"))
  end

  def self.adm
    self.adms.limit(1).first
  end

  def self.adms
    usuarios = Usuario.joins("inner join perfil_usuarios on usuarios.id = perfil_usuarios.usuario_id")
    usuarios = usuarios.where("usuarios.admin = true")
    usuarios
  end

  def admin?
    self.perfil_usuario.admin
  rescue
    false
  end

  def ultimo_acesso
    acesso = UsuarioAcesso.where(usuario_id: self.id).reorder("created_at desc").first
    acesso.created_at if acesso.present?
  end

  private

    def verifica_tamanho_senha
      #if self.senha.length > 10
      if self.senha.length > 30
        self.errors.add(:senha, "A senha não pode ser maior que 30 caracteres")
      elsif self.senha.blank? && self.id.blank?
        self.errors.add(:senha, "A senha não pode ficar em branco")
      end
    end

    def senha_sha1
      #self.senha = Digest::SHA1.hexdigest(self.senha) if self.senha.length <= 10
      self.senha = Digest::SHA1.hexdigest(self.senha) if self.senha.length <= 30
    end
end
