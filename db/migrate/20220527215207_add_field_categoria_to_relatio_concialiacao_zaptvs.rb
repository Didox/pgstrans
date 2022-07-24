class AddFieldCategoriaToRelatioConcialiacaoZaptvs < ActiveRecord::Migration[5.2]
  def change
    add_column :relatorio_conciliacao_zaptvs, :categoria, :string, default: "tv"
  end
end
