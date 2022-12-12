class DropTablePagasoErroCodigos < ActiveRecord::Migration[5.2]
  def change
    drop_table :pagaso_erro_codigos
  end
end
