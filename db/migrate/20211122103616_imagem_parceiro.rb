class ImagemParceiro < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :imagem, :string
  end
end
