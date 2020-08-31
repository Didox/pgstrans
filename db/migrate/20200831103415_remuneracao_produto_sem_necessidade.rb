class RemuneracaoProdutoSemNecessidade < ActiveRecord::Migration[5.2]
  def change
    remove_column :remuneracaos, :produto_id
  end
end
