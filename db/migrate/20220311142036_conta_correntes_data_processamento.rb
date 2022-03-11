class ContaCorrentesDataProcessamento < ActiveRecord::Migration[5.2]
  def change
    add_column :conta_correntes, :data_processamento, :datetime
  end
end
