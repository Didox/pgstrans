class ApiKeyZaptv < ActiveRecord::Migration[5.2]
  def change
    add_column :parametros, :api_key_zaptv_desenvolvimento, :string
    add_column :parametros, :api_key_zaptv_producao, :string
  end
end
