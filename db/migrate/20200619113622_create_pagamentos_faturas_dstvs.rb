class CreatePagamentosFaturasDstvs < ActiveRecord::Migration[5.2]
  def change
    create_table :pagamentos_faturas_dstvs do |t|
      t.text :request_body
      t.text :response_body
      t.string :customer_number
      t.float :valor
      t.string :smartcard
      t.bigint :administrador_id
      t.string :receipt_number
      t.string :transaction_number
      t.string :status
      t.string :transaction_date_time
      t.string :audit_reference_number

      t.timestamps
    end
  end
end
