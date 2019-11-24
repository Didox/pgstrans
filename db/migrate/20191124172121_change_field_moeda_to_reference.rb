class ChangeFieldMoedaToReference < ActiveRecord::Migration[5.2]
  def change
  	#remove_column :moedas, :moeda
  	#add_reference :moedas, :moeda, foreign_key: true
  end
end