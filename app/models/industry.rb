class Industry < ApplicationRecord
	validates :descr_curta, presence: true
	validates :descr_longa, presence: true
end
