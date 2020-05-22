class Remuneracao < ApplicationRecord
  include PermissionamentoDados
  belongs_to :usuario
  belongs_to :produto

  validates :usuario, uniqueness: { scope: [:usuario_id, :produto_id] }
end
