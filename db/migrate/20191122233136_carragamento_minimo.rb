class CarragamentoMinimo < ActiveRecord::Migration[5.2]
  def change
  	rename_column :canal_vendas, :carragamento_minimo, :carregamento_minimo
  end
end
