class CreateSubDistribuidors < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_distribuidors do |t|
      t.string :nome
      t.string :bi
      t.string :telefone
      t.string :morada
      t.string :municipio
      t.string :provincia

      t.timestamps
    end
  end
end
