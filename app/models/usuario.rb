class Usuario < ApplicationRecord
  include PermissionamentoDados
  
  has_many :matrix_users
  has_many :grupo_usuarios

  belongs_to :perfil_usuario
  belongs_to :sub_agente
  belongs_to :municipio
  belongs_to :status_cliente
  
  validates :email, :login, presence: true, uniqueness: true
  validates :nome, :email, presence: true

  validate :verifica_tamanho_senha
  after_validation :senha_sha1
  before_validation :preenche_login, :senha_forte

  def saldo
    ContaCorrente.where(usuario_id: self.id).order("data_ultima_atualizacao_saldo desc").first.saldo_atual
  rescue
	  0
  end

  def acessos
    return @acessos if @acessos.present?
    @acessos = perfil_usuario.acessos_actions
  end

  def self.gerar_login
    numero = 0
    while (numero.to_s.length < 7)
      numero = rand.to_s[2..8].to_i
    end
    numero
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

  def operador?
    self.perfil_usuario.operador
  rescue
    false
  end

  def agente?
    self.perfil_usuario.agente
  rescue
    false
  end

  def ultimo_acesso
    acesso = UsuarioAcesso.where(usuario_id: self.id).reorder("created_at desc").first
    acesso.created_at if acesso.present?
  end

  def valida_senha
    if self.senha.length < 6
      return false
    end

    simbolos_validos = '!@#$%^&*()[]{}?+|"\'\\/.,:;'

    testes_de_senha_obrigatorio = [
      /[#{Regexp.escape(simbolos_validos)}]/,
      /\d+/
    ]

    testes_de_senha_obrigatorio.each do |regexp|
      if self.senha.to_s.scan(regexp).length == 0
        return false
      end
    end

    testes_de_senha = [
      /[a-zA-Z]+/,                 
      /[a-z].*?[A-Z]|[A-Z].*[a-z]/,
      /.{10}/                      
    ]

    minimo_caractere_valido = 3

    quantidade_caractere_valido = testes_de_senha.sum do |regexp|
      self.senha.to_s.scan(regexp).length
    end

    if quantidade_caractere_valido < minimo_caractere_valido
      return false
    end

    return true
  end

  def senha_hexdigest?
    self.senha.match?(/^[0-9a-f]{40}$/)
  end

  private
    def verifica_tamanho_senha
      return if self.senha_hexdigest? && !self.new_record?

      if self.senha.length > 30
        self.errors.add(:senha, "A palavra-passe não pode ser maior que 30 caracteres")
      elsif self.senha.blank? && self.id.blank?
        self.errors.add(:senha, "A palavra-passe não pode ficar em branco")
      end
    end

    def senha_sha1
      if self.valida_senha
        self.senha = Digest::SHA1.hexdigest(self.senha)
        Usuario.where(id: self.id).where("senha <> '#{self.senha}'").update_all(logado: false)
      end
    end

    def preenche_login
      self.login = Usuario.gerar_login if self.login.blank?
    end

    def senha_forte
      return if self.senha_hexdigest? && !self.new_record?

      if self.senha.length < 6
        self.errors.add("Senha", "deve conter pelo menos 6 caracteres")
        return false
      end

      simbolos_validos = '!@#$%^&*()[]{}?+|"\'\\/.,:;'
  
      testes_de_senha_obrigatorio = [
        /[#{Regexp.escape(simbolos_validos)}]/,
        /\d+/
      ]
  
      testes_de_senha_obrigatorio.each do |regexp|
        if self.senha.to_s.scan(regexp).length == 0
          self.errors.add("Senha", "deve conter símbolos e números")
          return false
        end
      end
  
      testes_de_senha = [
        /[a-zA-Z]+/,                 
        /[a-z].*?[A-Z]|[A-Z].*[a-z]/,
        /.{10}/                      
      ]
  
      minimo_caractere_valido = 3
  
      quantidade_caractere_valido = testes_de_senha.sum do |regexp|
        self.senha.to_s.scan(regexp).length
      end
  
      if quantidade_caractere_valido < minimo_caractere_valido
        self.errors.add("Senha", "deve conter símbolos e números, letras maiúsculas e letras minúsculas")
        return false
      end
  
      return true
    end
end



