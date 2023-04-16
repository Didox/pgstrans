class ChangeNroPagamentoReferenciTipo < ActiveRecord::Migration[5.2]
  def change
    change_column :usuarios, :nro_pagamento_referencia, :string
    change_column :pagamento_referencias, :nro_pagamento_referencia, :string
  end
end
