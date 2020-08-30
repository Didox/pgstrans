class DataVigenciaProduto < ActiveRecord::Migration[5.2]
  def change
  	add_column :produtos, :data_vigencia, :datetime
  end
end
