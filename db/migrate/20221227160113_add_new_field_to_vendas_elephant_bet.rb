class AddNewFieldToVendasElephantBet < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :transaction_reference, :string
    add_column :vendas, :payment_code, :string
  end
end
