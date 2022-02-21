class AddFieldDescricaoIpapiAutorizados < ActiveRecord::Migration[5.2]
  def change
    add_column :ip_api_autorizados, :descricao, :string
  end
end
