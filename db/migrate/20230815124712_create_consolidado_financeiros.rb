class CreateConsolidadoFinanceiros < ActiveRecord::Migration[5.2]
  def change
    create_table :consolidado_financeiros do |t|
      t.integer :tipo
      t.text :parametros
      t.string :valor_total
      t.string :total_lucro
      t.string :total_custo
      t.references :usuario, foreign_key: true

      t.timestamps
    end
  end
end
