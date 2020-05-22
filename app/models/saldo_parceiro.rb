class SaldoParceiro < ApplicationRecord
  include PermissionamentoDados
  belongs_to :partner
end
