class SubDistribuidor < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
	validates :bi, :morada, presence: true

	belongs_to :municipio
	belongs_to :provincia, class_name: "Provincium", foreign_key: "provincia_id"
end
