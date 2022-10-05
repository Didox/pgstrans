class ModalInformativo < ApplicationRecord
    include PermissionamentoDados
    validates :titulo, :mensagem, presence: true
    
    def self.ativo
        ModalInformativo.where(ativa:true).first
    end
end
