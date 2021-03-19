class CreateStatusBancos < ActiveRecord::Migration[5.2]
  def change
    create_table :status_bancos do |t|
      t.string :nome
      t.timestamps
    end
  end
end
