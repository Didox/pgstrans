class PartnersSlug < ActiveRecord::Migration[5.2]
  def change
  	add_column :partners, :slug, :string
  end
end
