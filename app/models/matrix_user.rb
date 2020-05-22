class MatrixUser < ApplicationRecord
  include PermissionamentoDados
  belongs_to :usuario
  validates :usuario_id, :master_profile, :sub_distribuidor, :sub_agente, :filial, :pdv, presence: true
  # validates :usuario_id, uniqueness: true

  default_scope { order(id: :asc) }

  def master_profile_obj
    MasterProfile.find(self.master_profile) rescue MasterProfile.new
  end

  def sub_distribuidor_obj
    SubDistribuidor.find(self.sub_distribuidor) rescue SubDistribuidor.new
  end

  def sub_agente_obj
    SubAgente.find(self.sub_agente) rescue SubAgente.new
  end
end
