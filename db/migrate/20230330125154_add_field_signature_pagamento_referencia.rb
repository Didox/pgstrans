class AddFieldSignaturePagamentoReferencia < ActiveRecord::Migration[5.2]
  def change
    add_column :pagamento_referencias, :signature, :string
  end
end
