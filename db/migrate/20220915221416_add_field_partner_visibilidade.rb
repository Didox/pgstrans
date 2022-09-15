class AddFieldPartnerVisibilidade < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :usuarios, :text
  end
end
