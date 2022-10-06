class CreateConsolidadoVendas < ActiveRecord::Migration[5.2]
  def change
    create_table :consolidado_vendas do |t|
      t.text :parametros
      t.bigint :usuario_id

      t.timestamps
    end
  end
end
