class ParametrosGenericos < ActiveRecord::Migration[5.2]
  def change
    add_column :parametros, :dados, :text
  end
end
