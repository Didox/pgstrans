class DescontoPartner < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :desconto, :float, default: 0
  end
end
