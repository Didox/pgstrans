class CreateRemuneracaos < ActiveRecord::Migration[5.2]
  def change
    create_table :remuneracaos do |t|
      t.string :nome
      t.references :usuario, foreign_key: true
      t.references :produto, foreign_key: true
      t.float :valor_venda_final_telemovel
      t.float :valor_venda_final_site
      t.float :valor_venda_final_pos
      t.float :valor_venda_final_tef
      t.datetime :vigencia_inicio
      t.datetime :vigencia_fim

      t.timestamps
    end
  end
end
