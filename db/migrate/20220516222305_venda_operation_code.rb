class VendaOperationCode < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :operation_code_zap, :string
  end
end
