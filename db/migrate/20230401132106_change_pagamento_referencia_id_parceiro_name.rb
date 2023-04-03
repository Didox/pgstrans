class ChangePagamentoReferenciaIdParceiroName < ActiveRecord::Migration[5.2]
  def change
    rename_column :pagamento_referencias, :id_trn_parceiro, :id_parceiro
  end
end
