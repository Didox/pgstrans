class GrupoPaiCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :grupos, :pai, :boolean, default: false
  end
end
