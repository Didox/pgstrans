class CreateEmailHistoricoEnvios < ActiveRecord::Migration[5.2]
  def change
    create_table :email_historico_envios do |t|
      t.string :email
      t.string :titulo
      t.text :conteudo
      t.references :usuario, foreign_key: true
      t.bigint :venda_id
      t.boolean :sucesso

      t.timestamps
    end
  end
end
