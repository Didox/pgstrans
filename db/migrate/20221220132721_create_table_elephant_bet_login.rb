class CreateTableElephantBetLogin < ActiveRecord::Migration[5.2]
  def change
    create_table :elephant_bet_logins do |t|
      t.text :body_request

      t.timestamps
    end
  end
end

