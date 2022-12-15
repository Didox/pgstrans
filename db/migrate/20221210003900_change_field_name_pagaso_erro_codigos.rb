class ChangeFieldNamePagasoErroCodigos < ActiveRecord::Migration[5.2]
  def change
    rename_column :pagaso_erro_codigos, :messagem, :mensagem
  end
end
