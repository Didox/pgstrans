class ChangePagamentoReferenciaIdType < ActiveRecord::Migration[5.2]
  def change
    change_column :pagamento_referencias, :id_trn_parceiro, :string
  end
end
