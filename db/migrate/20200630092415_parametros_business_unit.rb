class ParametrosBusinessUnit < ActiveRecord::Migration[5.2]
  def change
    add_column :parametros, :business_unit_desenvolvimento, :string
    add_column :parametros, :business_unit_producao, :string
    add_column :parametros, :language_desenvolvimento, :string
    add_column :parametros, :language_producao, :string
  end
end
