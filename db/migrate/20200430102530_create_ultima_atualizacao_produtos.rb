class CreateUltimaAtualizacaoProdutos < ActiveRecord::Migration[5.2]
  def change
    create_table :ultima_atualizacao_produtos do |t|
      t.references :partner, foreign_key: true

      t.timestamps
    end
  end
end
