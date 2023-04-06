class CreateUsuarioReferenciaPagamentos < ActiveRecord::Migration[5.2]
  def change
    create_table :usuario_referencia_pagamentos do |t|
      t.references :usuario, foreign_key: true
      t.string :nro_pagamento_referencia
      t.integer :acao

      t.timestamps
    end
  end
end
