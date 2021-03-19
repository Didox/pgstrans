class IncluirCamposTabelaBancos < ActiveRecord::Migration[5.2]
  def change
    add_column :bancos, :ordem_prioridade, :integer
    add_column :bancos, :whatsapp, :string
    remove_column :bancos, :fax_sede
    remove_column :bancos, :fax_escritorio
  end
end
