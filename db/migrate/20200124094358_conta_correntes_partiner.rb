class ContaCorrentesPartiner < ActiveRecord::Migration[5.2]
  def change
  	add_reference :conta_correntes, :partner, foreign_key: true
  end
end
