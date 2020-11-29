class MovicelLoop < ApplicationRecord
	validates :usuario, :token, :uri, presence: true
end
