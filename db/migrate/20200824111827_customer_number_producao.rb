class CustomerNumberProducao < ActiveRecord::Migration[5.2]
  def change
    add_column :parametros, :customer_number_desenvolvimento, :string
  end
end
