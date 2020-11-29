class CreateMovicelLoops < ActiveRecord::Migration[5.2]
  def change
    create_table :movicel_loops do |t|
      t.string :usuario
      t.string :token
      t.string :uri
      t.string :ambiente
      t.string :agente
      t.string :terminal
      t.float :valor
      t.integer :repeticao
      t.decimal :nropedidoinicio
      t.decimal :nropedido
      t.string :request
      t.string :response

      t.timestamps
    end
  end
end
