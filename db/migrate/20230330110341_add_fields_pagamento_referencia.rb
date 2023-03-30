class AddFieldsPagamentoReferencia < ActiveRecord::Migration[5.2]
  def change
    add_column :pagamento_referencia, :transaction_id_parceiro, :string
    add_column :pagamento_referencia, :terminal_transaction_id_parceiro, :string
    add_column :pagamento_referencia, :product_id_parceiro, :string
    add_column :pagamento_referencia, :period_start_datetime_parceiro, :datetime
    add_column :pagamento_referencia, :period_end_datetime_parceiro, :datetime
    add_column :pagamento_referencia, :parameter_id_parceiro, :string
    add_column :pagamento_referencia, :period_id_parceiro, :string
    add_column :pagamento_referencia, :fee_parceiro, :string
    add_column :pagamento_referencia, :entity_id_parceiro, :string
    add_column :pagamento_referencia, :custom_fields_parceiro, :string
    add_column :pagamento_referencia, :status, :boolean, default: false
    rename_column :pagamento_referencia, :terminal_id, :terminal_id_parceiro
    rename_column :pagamento_referencia, :terminal_location, :terminal_location_parceiro
    rename_column :pagamento_referencia, :terminal_type, :terminal_type_parceiro
    rename_column :pagamento_referencia, :valor_pagamento, :valor
  end
end
