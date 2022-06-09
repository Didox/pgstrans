class AddFieldIdVendaContaCorrente < ActiveRecord::Migration[5.2]
  def change
    add_column :conta_correntes, :venda_id, :bigint
  end
end
