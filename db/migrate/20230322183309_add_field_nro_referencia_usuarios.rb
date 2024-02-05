class AddFieldNroReferenciaUsuarios < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :nro_pagamento_referencia, :bigint
  end
end
