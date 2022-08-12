class CreateModalInformativos < ActiveRecord::Migration[5.2]
  def change
    create_table :modal_informativos do |t|
      t.string :titulo
      t.text :mensagem
      t.datetime :validade_inicio
      t.datetime :validade_fim

      t.timestamps
    end
  end
end
