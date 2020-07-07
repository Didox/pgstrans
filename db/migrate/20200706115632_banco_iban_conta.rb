class BancoIbanConta < ActiveRecord::Migration[5.2]
  def change
  	add_column :bancos, :iban, :string
  	add_column :bancos, :conta_bancaria, :string
  end
end