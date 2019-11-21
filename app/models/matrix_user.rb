class MatrixUser < ApplicationRecord
  belongs_to :usuario
  validates :usuario_id, presence: true, uniqueness: true
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
