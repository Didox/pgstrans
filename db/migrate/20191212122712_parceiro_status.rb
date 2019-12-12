class ParceiroStatus < ActiveRecord::Migration[5.2]
  def change
  	add_reference :partners, :status_parceiro, foreign_key: true
  end
end
