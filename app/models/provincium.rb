class Provincium < ApplicationRecord
  include PermissionamentoDados
  belongs_to :country
  validates :nome, presence: true, uniqueness: true
  validates :capital, presence: true
end
