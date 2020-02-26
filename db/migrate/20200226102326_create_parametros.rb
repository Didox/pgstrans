class CreateParametros < ActiveRecord::Migration[5.2]
  def change
    create_table :parametros do |t|
      t.string :url_integracao_desenvolvimento
      t.string :url_integracao_producao
      t.references :partner, foreign_key: true
      t.string :agent_key_movicel_desenvolvimento
      t.string :agent_key_movicel_producao
      t.string :user_id_movicel_desevolvimento
      t.string :user_id_movicel_producao
      t.string :data_source_dstv_desevolvimento
      t.string :data_source_dstv_producao
      t.string :payment_vendor_code_dstv_desenvolvimento
      t.string :payment_vendor_code_dstv_producao
      t.string :vendor_code_dstv_desenvolvimento
      t.string :vendor_code_dstv_producao
      t.string :agent_account_dstv_desenvolvimento
      t.string :agent_account_dstv_producao
      t.string :currency_dstv_desenvolvimento
      t.string :currency_dstv_producao
      t.string :product_user_key_dstv_desenvolvimento
      t.string :product_user_key_dstv_producao
      t.string :mop_dstv_desenvolvimento
      t.string :mop_dstv_producao

      t.timestamps
    end
  end
end
