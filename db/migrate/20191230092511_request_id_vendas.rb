class RequestIdVendas < ActiveRecord::Migration[5.2]
  def change
  	add_column :vendas, :request_id, :string
  	drop_table :topup_validations
	drop_table :topup_recargas
	drop_table :query_requests
	drop_table :query_balances
  end
end
