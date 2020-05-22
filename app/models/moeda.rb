class Moeda < ApplicationRecord
  include PermissionamentoDados
  belongs_to :country
end
