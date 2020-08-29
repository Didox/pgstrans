class CreateRemuneracaoDescontos < ActiveRecord::Migration[5.2]
  def change
    create_table :remuneracao_descontos do |t|
      t.references :remuneracao, foreign_key: true
      t.references :partner, foreign_key: true
      t.references :desconto_parceiro, foreign_key: true

      t.timestamps
    end
  end
end
