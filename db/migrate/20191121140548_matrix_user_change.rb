class MatrixUserChange < ActiveRecord::Migration[5.2]
  def change
  	remove_column :matrix_users, :user_id
  	add_reference :matrix_users, :usuario, foreign_key: true
  end
end
