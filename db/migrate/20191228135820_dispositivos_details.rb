class DispositivosDetails < ActiveRecord::Migration[5.2]
  def change
  	add_column :dispositivos, :so, :string
  	add_column :dispositivos, :ram_rom, :string
  	add_column :dispositivos, :conectividade, :string
  end
end
