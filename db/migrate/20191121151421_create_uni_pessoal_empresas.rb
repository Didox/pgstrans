class CreateUniPessoalEmpresas < ActiveRecord::Migration[5.2]
  def change
    create_table :uni_pessoal_empresas do |t|
      t.string :nome

      t.timestamps
    end
  end
end
