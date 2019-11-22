class Country < ApplicationRecord
	validates :name_eng, presence: true, uniqueness: true
 	validates :name_pt, presence: true
end
