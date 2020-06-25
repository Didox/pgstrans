class UniPessoalEmpresasIdCorreto < ActiveRecord::Migration[5.2]
  def change
    remove_column :sub_agentes, :uni_pessoal_empresas_id
  	add_reference :sub_agentes, :uni_pessoal_empresa, foreign_key: true
  end
end
