class RemoveLixoVendas < ActiveRecord::Migration[5.2]
  def change
    remove_column :vendas, :pagamentos_faturas_dstv_id
    remove_column :vendas, :alteracoes_planos_dstv_id

    drop_table :pagamentos_faturas_dstvs
    drop_table :alteracoes_planos_dstvs
  end
end
