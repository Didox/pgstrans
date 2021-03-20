class IncluirCamposTabelaUsuarios < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :telefone, :string
    add_column :usuarios, :whatsapp, :string
    add_column :usuarios, :data_adesao, :datetime
  end
end
