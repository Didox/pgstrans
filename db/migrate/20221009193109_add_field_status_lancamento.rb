class AddFieldStatusLancamento < ActiveRecord::Migration[5.2]
  def change
    add_column :lancamentos, :status, :boolean
  end
end
