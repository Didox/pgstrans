class SubDistribuidorsCamposNovos < ActiveRecord::Migration[5.2]
  def change
    add_column :sub_distribuidors, :ramo_negociacao, :string
    add_column :sub_distribuidors, :site, :string
    add_column :sub_distribuidors, :interface_operacao, :string
  end
end
