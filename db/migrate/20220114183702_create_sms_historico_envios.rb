class CreateSmsHistoricoEnvios < ActiveRecord::Migration[5.2]
  def change
    create_table :sms_historico_envios do |t|
      t.string :numero
      t.text :conteudo
      t.references :usuario, foreign_key: true
      t.bigint :venda_id
      t.boolean :sucesso

      t.timestamps
    end
  end
end
