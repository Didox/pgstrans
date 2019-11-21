class CreateLancamentos < ActiveRecord::Migration[5.2]
  def change
    create_table :lancamentos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
