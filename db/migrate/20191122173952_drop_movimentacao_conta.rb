class DropMovimentacaoConta < ActiveRecord::Migration[5.2]
  def change
  	drop_table :movimentacao_conta
  end
end
