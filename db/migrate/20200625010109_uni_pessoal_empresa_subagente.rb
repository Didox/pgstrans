class UniPessoalEmpresaSubagente < ActiveRecord::Migration[5.2]
  def change
  	add_reference :sub_agentes, :uni_pessoal_empresas, foreign_key: true
  end
end
