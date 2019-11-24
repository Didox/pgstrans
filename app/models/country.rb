class Country < ApplicationRecord
	validates :name_eng, :bacen, presence: true, uniqueness: true
 	validates :name_pt, presence: true
end
