class CreateSequencialDstvs < ActiveRecord::Migration[5.2]
  def change
    create_table :sequencial_dstvs do |t|
      t.integer :numero

      t.timestamps
    end
  end
end
