class StatusProduto < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
end
