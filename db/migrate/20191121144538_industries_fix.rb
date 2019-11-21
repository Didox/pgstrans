class IndustriesFix < ActiveRecord::Migration[5.2]
  def change
     rename_column :industries, :descr_curta, :descricao_seccao
     rename_column :industries, :descr_longa, :descricao_divisao
     add_column :industries, :descricao_grupo, :string
  end
end
