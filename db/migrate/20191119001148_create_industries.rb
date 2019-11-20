class CreateIndustries < ActiveRecord::Migration[5.2]
  def change
    create_table :industries do |t|
      t.string :descr_curta
      t.string :descr_longa

      t.timestamps
    end
  end
end
