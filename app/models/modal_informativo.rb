class ModalInformativo < ApplicationRecord
    include PermissionamentoDados
    validates :titulo, :mensagem, presence: true
    
end
