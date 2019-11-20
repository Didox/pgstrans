class CreateProdutos < ActiveRecord::Migration[5.2]
  def change
    create_table :produtos do |t|
      t.string :description
      t.references :partner, foreign_key: true
      t.references :status_produto, foreign_key: true
      t.float :valor_compra_telemovel
      t.float :valor_compra_site
      t.float :valor_compra_pos
      t.float :valor_compra_tef
      t.float :valor_minimo_venda_telemovel
      t.float :valor_minimo_venda_site
      t.float :valor_minimo_venda_pos
      t.float :valor_minimo_venda_tef
      t.float :margem_telemovel
      t.string :margem_site
      t.float :margem_pos
      t.float :margem_tef
      t.text :mensagem_cupom_venda

      t.timestamps
    end
  end
end
