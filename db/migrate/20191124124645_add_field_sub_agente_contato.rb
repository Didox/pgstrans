class AddFieldSubAgenteContato < ActiveRecord::Migration[5.2]
  def change
  	add_column :sub_agentes, :contato, :string
  end
end
