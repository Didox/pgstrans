class MasterProfile < ApplicationRecord
	validates :id, presence: true, uniqueness: true
end
