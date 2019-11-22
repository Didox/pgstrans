class Provincium < ApplicationRecord
  belongs_to :country
  validates :nome, presence: true, uniqueness: true
  validates :capital, presence: true
end
