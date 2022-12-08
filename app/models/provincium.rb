class Provincium < ApplicationRecord
  include PermissionamentoDados
  belongs_to :country
  validates :nome, presence: true, uniqueness: true
  validates :capital, presence: true

  def municipios
    @result_provincia ||= Municipio.where(provincia_id: self.id)
    return @result_provincia 
  end
end
