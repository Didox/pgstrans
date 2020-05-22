class Parametro < ApplicationRecord
  include PermissionamentoDados
  belongs_to :partner
end
