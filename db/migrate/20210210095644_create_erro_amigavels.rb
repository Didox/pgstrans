class CreateErroAmigavels < ActiveRecord::Migration[5.2]
  def change
    create_table :erro_amigavels do |t|
      t.string :de
      t.string :para

      t.timestamps
    end
  end
end
