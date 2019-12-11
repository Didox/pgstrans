class CorrecoesVenda < ActiveRecord::Migration[5.2]
  def change
	remove_column :return_code_apis, :partner_code
    add_reference :return_code_apis, :partner, foreign_key: true
    add_reference :vendas, :partner, foreign_key: true
    add_reference :vendas, :usuario, foreign_key: true
  end
end
