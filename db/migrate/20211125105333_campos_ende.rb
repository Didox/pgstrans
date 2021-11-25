class CamposEnde < ActiveRecord::Migration[5.2]
  def change
    add_column :parametros, :api_key_ende_desenvolvimento, :string
    add_column :parametros, :api_key_ende_producao, :string
  end
end
