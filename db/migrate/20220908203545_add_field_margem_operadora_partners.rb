class AddFieldMargemOperadoraPartners < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :margem_operadora, :float
  end
end
