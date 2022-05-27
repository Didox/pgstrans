class AddFieldCategoriaToRelatorio < ActiveRecord::Migration[5.2]
  def change
    add_column :relatorios, :categoria, :string, default: "tv"
  end
end
