class RemuneracaoAtivoInativo < ActiveRecord::Migration[5.2]
  def change
    add_column :remuneracaos, :ativo, :boolean, default:true
  end
end
