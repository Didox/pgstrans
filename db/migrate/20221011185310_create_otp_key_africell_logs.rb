class CreateOtpKeyAfricellLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :otp_key_africell_logs do |t|
      t.datetime :data
      t.string :log

      t.timestamps
    end
  end
end
