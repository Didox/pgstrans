class CreateSubAgentes < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_agentes do |t|
      t.string :razao_social
      t.string :nome_fantasia
      t.string :bi
      t.string :industry_id
      t.string :morada
      t.string :bairro
      t.string :provincia
      t.string :email
      t.string :telefone

      t.timestamps
    end
  end
end
