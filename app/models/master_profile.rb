class MasterProfile < ApplicationRecord
  include PermissionamentoDados
  validates :description, presence: true, uniqueness: true
end
