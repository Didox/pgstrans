class Banco < ApplicationRecord
  include PermissionamentoDados
  validates :nome, :sigla, presence: true, uniqueness: true
  has_many :conta_correntes, dependent: :destroy
end
