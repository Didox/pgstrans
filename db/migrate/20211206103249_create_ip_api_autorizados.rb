class CreateIpApiAutorizados < ActiveRecord::Migration[5.2]
  def change
    create_table :ip_api_autorizados do |t|
      t.string :ip
      t.references :sub_distribuidor, foreign_key: true

      t.timestamps
    end
  end
end
