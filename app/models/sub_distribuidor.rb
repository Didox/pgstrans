class SubDistribuidor < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
	validates :bi, :morada, presence: true
end
