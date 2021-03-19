class Banco < ApplicationRecord
  include PermissionamentoDados
  validates :nome, :sigla, presence: true, uniqueness: true
  has_many :conta_correntes
  belongs_to :status_banco
end
