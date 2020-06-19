class CreateAlteracoesPlanosDstvs < ActiveRecord::Migration[5.2]
  def change
    create_table :alteracoes_planos_dstvs do |t|
      t.text :request_body
      t.text :response_body
      t.text :customer_number
      t.text :smartcard
      t.text :produto
      t.bigint :administrador_id
      t.string :produto
      t.string :codigo
      t.float :valor
      t.string :receipt_number
      t.string :transaction_number
      t.string :status
      t.string :transaction_date_time
      t.string :error_message
      t.string :audit_reference_number

      t.timestamps
    end
  end
end
