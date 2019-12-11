class VendaStatus < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendas, :status, :string
  end
end
