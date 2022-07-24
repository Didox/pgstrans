class VendaZappi < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :zappi, :string
  end
end
