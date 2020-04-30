class CreateUltimaAtualizacaoReconciliacaos < ActiveRecord::Migration[5.2]
  def change
    create_table :ultima_atualizacao_reconciliacaos do |t|
      t.references :partner, foreign_key: true

      t.timestamps
    end
  end
end
