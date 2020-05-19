class GrupoPai < ActiveRecord::Migration[5.2]
  def change
    add_column :grupos, :grupo_id, :bigint
  end
end
