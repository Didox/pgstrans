class MatrixUser < ApplicationRecord
	validates :user_id, presence: true, uniqueness: true
	validates :master_profile, presence: true
	validates :sub_dist, presence: true
	validates :sub_agent, presence: true
	validates :filial, presence: true
	validates :pdv, presence: true
end


