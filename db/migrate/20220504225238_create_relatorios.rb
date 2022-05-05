class CreateRelatorios < ActiveRecord::Migration[5.2]
  def change
    create_table :relatorios do |t|
      t.integer :partner_id
      t.string :arquivo
      t.string :parametros

      t.timestamps
    end
  end
end
