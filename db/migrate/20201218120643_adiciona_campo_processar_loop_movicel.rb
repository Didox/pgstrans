class AdicionaCampoProcessarLoopMovicel < ActiveRecord::Migration[5.2]
  def change
    add_column :movicel_loops, :processar_loop, :boolean, default:false
  end
end
