class RemoveCamposMovicelLoops < ActiveRecord::Migration[5.2]
  def change
    remove_column :movicel_loops, :request
    remove_column :movicel_loops, :response
  end
end
