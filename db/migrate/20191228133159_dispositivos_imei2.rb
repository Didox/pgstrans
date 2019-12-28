class DispositivosImei2 < ActiveRecord::Migration[5.2]
  def change
  	add_column :dispositivos, :imei2, :string
  	add_column :dispositivos, :rated, :string
  	add_column :dispositivos, :screensize, :string
  end
end
