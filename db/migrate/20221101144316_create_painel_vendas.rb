class CreatePainelVendas < ActiveRecord::Migration[5.2]
  def change
    create_table :painel_vendas do |t|

      t.timestamps
    end
  end
end
