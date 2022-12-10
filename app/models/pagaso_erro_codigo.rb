class PagasoErroCodigo < ApplicationRecord
    include PermissionamentoDados
    validates :de, :para, :mensagem, presence: true
end
