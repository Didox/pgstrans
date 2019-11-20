class SubDistribuidor < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
	validates :bi, presence: true, uniqueness: true
end
