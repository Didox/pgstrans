class AddFieldVendaLogErro < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :log_erro_text, :text
  end
end
