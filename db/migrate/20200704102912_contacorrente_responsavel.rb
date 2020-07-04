class ContacorrenteResponsavel < ActiveRecord::Migration[5.2]
  def change
    add_column :conta_correntes, :responsavel_aprovacao_id, :bigint
  end
end
