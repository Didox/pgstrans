class CreateBancos < ActiveRecord::Migration[5.2]
  def change
    create_table :bancos do |t|
      t.string :nome
      t.string :sigla
      t.string :morada_sede
      t.string :telefone_sede
      t.string :fax_sede
      t.string :morada_escritorio
      t.string :telefone_escritorio
      t.string :fax_escritorio
      t.string :website
      t.string :email
      t.string :logomarca

      t.timestamps
  end
end
