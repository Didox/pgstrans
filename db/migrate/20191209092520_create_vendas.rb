class CreateVendas < ActiveRecord::Migration[5.2]
  def change
    create_table :vendas do |t|
      t.string :sequence_id
      t.string :product_id
      t.string :agent_id
      t.string :store_id
      t.string :seller_id
      t.string :terminal_id
      t.float :value
      t.string :client_msisdn
      t.text :request_send
      t.text :response_get

      t.timestamps
    end
  end
end
