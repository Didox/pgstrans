class StatusBanco < ApplicationRecord
    include PermissionamentoDados
    validates :nome, presence: true, uniqueness: true
end
