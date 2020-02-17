class CreateRelatorioConciliacaoZaptvs < ActiveRecord::Migration[5.2]
  def change
    create_table :relatorio_conciliacao_zaptvs do |t|
      t.references :partner, foreign_key: true
      t.string :url
      t.string :operation_code
      t.string :source_reference
      t.bigint :product_code
      t.integer :quantity
      t.datetime :date_time
      t.string :type_data
      t.float :total_price
      t.string :status
      t.float :unit_price

      t.timestamps
    end
  end
end
