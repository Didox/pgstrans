class AddFieldsToBancos < ActiveRecord::Migration[5.2]
  def change
  	add_column :bancos, :sigla, :string
  	add_column :bancos, :morada_sede, :string
  	add_column :bancos, :telefone_sede, :string
  	add_column :bancos, :fax_sede, :string
  	add_column :bancos, :morada_escritorio, :string
  	add_column :bancos, :telefone_escritorio, :string
  	add_column :bancos, :fax_escritorio, :string
  	add_column :bancos, :website, :string
  	add_column :bancos, :email, :string
  	add_column :bancos, :logomarca, :string
  end
end