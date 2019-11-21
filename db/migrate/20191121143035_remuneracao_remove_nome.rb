class RemuneracaoRemoveNome < ActiveRecord::Migration[5.2]
  def change
  	remove_column :remuneracaos, :nome
  end
end
