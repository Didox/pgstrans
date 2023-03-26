class AddFieldNroReferenciaUsuarios < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :nro_pagamento_referencia, :bigint, limit: 9
  end
end
