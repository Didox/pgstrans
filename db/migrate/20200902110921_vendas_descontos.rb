class VendasDescontos < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :desconto_aplicado, :float, default: 0
    add_column :vendas, :valor_original, :float, default: 0
  end
end
