class ConsolidadoQuery < ActiveRecord::Migration[5.2]
  def change
    add_column :consolidado_financeiros, :query, :text
  end
end
