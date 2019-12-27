class OrdemParceiros < ActiveRecord::Migration[5.2]
  def change
  	add_column :partners, :order, :integer
  end
end
