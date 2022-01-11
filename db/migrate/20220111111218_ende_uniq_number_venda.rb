class EndeUniqNumberVenda < ActiveRecord::Migration[5.2]
  def change
    add_column :ende_uniq_numbers, :venda_id, :integer
  end
end
