class CreateLoopLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :loop_logs do |t|
      t.text :request
      t.text :response
      t.references :movicel_loop, foreign_key: true

      t.timestamps
    end
  end
end
