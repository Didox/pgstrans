class UsuarioMasterProfile < ActiveRecord::Migration[5.2]
  def change
  	add_reference :usuarios, :master_profile, foreign_key: true, default: 1
  end
end
