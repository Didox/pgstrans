class AcessosMasterProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :master_profiles, :acessos, :text
  end
end
