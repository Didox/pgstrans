class CreateEndeUniqNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :ende_uniq_numbers do |t|
      t.datetime :data

      t.timestamps
    end
  end
end
