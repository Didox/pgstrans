class CreateMatrixUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :matrix_users do |t|
      t.bigint :user_id
      t.integer :master_profile
      t.integer :sub_dist
      t.integer :sub_agent
      t.integer :filial
      t.integer :pdv

      t.timestamps
    end
  end
end
