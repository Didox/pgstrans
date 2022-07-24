class UltimaAtualizacaoReconciliacaosCategoria < ActiveRecord::Migration[5.2]
  def change
    add_column :ultima_atualizacao_reconciliacaos, :categoria, :string, default: "tv"
  end
end
