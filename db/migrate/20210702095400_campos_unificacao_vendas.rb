class CamposUnificacaoVendas < ActiveRecord::Migration[5.2]
  def change
  	add_reference :vendas, :lancamento, foreign_key: true, default: 6
    add_column :vendas, :receipt_number, :string
    add_column :vendas, :transaction_number, :string
    add_column :vendas, :transaction_date_time, :string
    add_column :vendas, :error_message, :string
    add_column :vendas, :tipo_plano, :string, default: "mensal"
    add_column :vendas, :audit_reference_number, :string
    add_column :vendas, :pagamentos_faturas_dstv_id, :integer
    add_column :vendas, :alteracoes_planos_dstv_id, :integer
    add_column :vendas, :smartcard, :string
    add_column :vendas, :codigos_produto, :string
    rename_column :vendas, :client_msisdn, :customer_number
  end
end
