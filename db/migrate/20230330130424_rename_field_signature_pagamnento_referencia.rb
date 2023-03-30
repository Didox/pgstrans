class RenameFieldSignaturePagamnentoReferencia < ActiveRecord::Migration[5.2]
  def change
    rename_column :pagamento_referencias, :signature, :x_signature
  end
end
