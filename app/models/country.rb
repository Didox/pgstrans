class Country < ApplicationRecord
    include PermissionamentoDados
	validates :name_eng, :bacen, presence: true, uniqueness: true
 	validates :name_pt, presence: true
end
