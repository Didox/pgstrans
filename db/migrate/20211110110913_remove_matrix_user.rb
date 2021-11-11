class RemoveMatrixUser < ActiveRecord::Migration[5.2]
  def change
	  drop_table :matrix_users
  end
end
