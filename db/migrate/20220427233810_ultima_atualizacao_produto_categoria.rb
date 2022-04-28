class UltimaAtualizacaoProdutoCategoria < ActiveRecord::Migration[5.2]
  def change
    add_column :ultima_atualizacao_produtos, :categoria, :string
  end
end