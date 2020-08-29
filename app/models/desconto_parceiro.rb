class DescontoParceiro < ApplicationRecord
  belongs_to :partner

  validates :porcentagem, uniqueness: { scope: [:porcentagem, :partner_id] }
end
