class CreateDescontoParceiros < ActiveRecord::Migration[5.2]
  def change
    create_table :desconto_parceiros do |t|
      t.float :porcentagem
      t.references :partner, foreign_key: true

      t.timestamps
    end
  end
end
