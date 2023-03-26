class AddFieldPortfolioVendasPartners < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :portfolio_venda, :boolean, default: true
  end
end
