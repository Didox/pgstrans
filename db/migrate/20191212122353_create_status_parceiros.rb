class CreateStatusParceiros < ActiveRecord::Migration[5.2]
  def change
    create_table :status_parceiros do |t|
      t.string :nome

      t.timestamps
    end
  end
end
