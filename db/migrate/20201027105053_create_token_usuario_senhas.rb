class CreateTokenUsuarioSenhas < ActiveRecord::Migration[5.2]
  def change
    create_table :token_usuario_senhas do |t|
      t.string :token
      t.references :usuario, foreign_key: true

      t.timestamps
    end
  end
end
