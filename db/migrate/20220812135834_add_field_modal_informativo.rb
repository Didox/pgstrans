class AddFieldModalInformativo < ActiveRecord::Migration[5.2]
  def change
    add_column :modal_informativos, :ativa, :boolean, default: true
    remove_column :modal_informativos, :validade_inicio
    remove_column :modal_informativos, :validade_fim
  end
end
