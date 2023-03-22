class CreatePagamentoReferencia < ActiveRecord::Migration[5.2]
  def change
    create_table :pagamento_referencia do |t|
      t.references :usuario
      t.integer :nro_pagamento_referencia
      t.integer :id_trn_parceiro
      t.float :valor_pagamento
      t.datetime :data_pagamento
      t.datetime :data_conciliacao
      t.string :terminal_id
      t.string :terminal_location
      t.string :terminal_type

      t.timestamps
    end
  end
end
