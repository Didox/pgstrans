class AddNewFieldCanalVendaVendas < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :canal_venda, :string
  end
end
