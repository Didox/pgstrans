class CreateMasterProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :master_profiles do |t|
      t.string :description

      t.timestamps
    end
  end
end
