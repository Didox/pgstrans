class CreateAfricellLogins < ActiveRecord::Migration[5.2]
  def change
    create_table :africell_logins do |t|
      t.text :body_request

      t.timestamps
    end
  end
end
