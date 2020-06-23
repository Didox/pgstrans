class AlteracoesPlanosDstv < ActiveRecord::Migration[5.2]
  def change
    add_column :alteracoes_planos_dstvs, :tipo_plano, :string, default: "mensal"
  end
end
