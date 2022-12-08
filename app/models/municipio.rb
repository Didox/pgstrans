class Municipio < ApplicationRecord
	include PermissionamentoDados
	
	def provincia
		Provincium.find(self.provincia_id)
	rescue
		nil
	end

	validates :nome, presence: true, uniqueness: true
end
