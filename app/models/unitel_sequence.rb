class UnitelSequence < ApplicationRecord
  include PermissionamentoDados
  belongs_to :venda
end
