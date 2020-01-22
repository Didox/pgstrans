class ReturnCodeApi < ActiveRecord::Migration[5.2]
  def change
  	add_column :return_code_apis, :sucesso, :boolean
  end
end
