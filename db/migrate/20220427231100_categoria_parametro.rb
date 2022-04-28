class CategoriaParametro < ActiveRecord::Migration[5.2]
  def change
    add_column :parametros, :categoria, :string
  end
end
