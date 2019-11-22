class MasterProfile < ApplicationRecord
	validates :description, presence: true, uniqueness: true
end
