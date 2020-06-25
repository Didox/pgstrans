class UniPessoalEmpresaSubagente < ActiveRecord::Migration[5.2]
  def change
  	add_column :sub_agentes, :unipessoal_empresa_id, :bigint
  end
end
