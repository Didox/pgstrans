class ReturnCodeApi < ApplicationRecord
	include PermissionamentoDados
	belongs_to :partner
end
