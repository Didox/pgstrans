class CreateTipoTransacaos < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_transacaos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
