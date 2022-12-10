class CreatePagasoErroCodigos < ActiveRecord::Migration[5.2]
  def change
    create_table :pagaso_erro_codigos do |t|
      t.string :de
      t.string :para
      t.string :mensagem

      t.timestamps
    end
  end
end
