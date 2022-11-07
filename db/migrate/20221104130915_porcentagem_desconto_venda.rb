class PorcentagemDescontoVenda < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :porcentagem_desconto, :float
  end
end
