class PerfilUsuario < ApplicationRecord
  validates :nome, presence: true, uniqueness: true

  def acessos_parse
    self.acessos.present? ? JSON.parse(self.acessos) : []
  rescue
	 []
  end

  def acessos_actions
    acessos_parse.map{|a|a["acesso"]}
  rescue
    []
  end

  def acessos_views
    acessos_parse.map{|a|a["views"]}.uniq.compact.flatten
  rescue
    []
  end
end
