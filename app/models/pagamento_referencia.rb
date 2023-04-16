class PagamentoReferencia < ApplicationRecord
    self.table_name = "pagamento_referencias"
    include PermissionamentoDados
    belongs_to :usuario
end
