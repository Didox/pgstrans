class CreateUnitelSequences < ActiveRecord::Migration[5.2]
  def change
    create_table :unitel_sequences do |t|
      t.integer :sequence_id
      t.references :venda, foreign_key: true

      t.timestamps
    end
  end
end
