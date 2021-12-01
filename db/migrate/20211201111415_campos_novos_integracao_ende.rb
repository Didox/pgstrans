class CamposNovosIntegracaoEnde < ActiveRecord::Migration[5.2]
  def change
    add_column :parametros, :client_id, :string
    add_column :parametros, :terminal_id, :string
    add_column :parametros, :operator_id, :string
    add_column :parametros, :password, :string
  end
end
