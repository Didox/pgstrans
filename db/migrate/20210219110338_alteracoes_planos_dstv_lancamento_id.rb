class AlteracoesPlanosDstvLancamentoId < ActiveRecord::Migration[5.2]
  def change
    add_column :alteracoes_planos_dstvs, :lancamento_id, :integer
  end
end
