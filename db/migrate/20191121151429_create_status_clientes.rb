class CreateStatusClientes < ActiveRecord::Migration[5.2]
  def change
    create_table :status_clientes do |t|
      t.string :nome

      t.timestamps
    end
  end
end
