class ChangePagamentoReferenciaTableName < ActiveRecord::Migration[5.2]
  def change
    rename_table :pagamento_referencia, :pagamento_referencias
  end
end
