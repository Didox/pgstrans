class CreateMovimentacaoConta < ActiveRecord::Migration[5.2]
  def change
    create_table :movimentacao_conta do |t|
      t.string :nome

      t.timestamps
    end
  end
end
