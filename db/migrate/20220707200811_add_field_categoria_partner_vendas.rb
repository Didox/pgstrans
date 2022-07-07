class AddFieldCategoriaPartnerVendas < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :categoria, :string
  end
end
