class Remuneracao < ApplicationRecord
  include PermissionamentoDados
  belongs_to :usuario
end