class Partner < ApplicationRecord
  has_many :return_code_api
  validates :name, presence: true, uniqueness: true
  belongs_to :status_parceiro
end
