class UsuarioMorada < ActiveRecord::Migration[5.2]
  def change
  	add_column :usuarios, :morada, :string
  	add_column :usuarios, :bairro, :string
  	add_reference :usuarios, :municipio, foreign_key: true
  	add_reference :usuarios, :provincia, foreign_key: true
  	add_reference :usuarios, :industry, foreign_key: true
  	add_reference :usuarios, :uni_pessoal_empresa, foreign_key: true
  end
end

