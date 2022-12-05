class AddNewFieldRelatoriosController < ActiveRecord::Migration[5.2]
  def change
    add_column :relatorios, :controller_acao, :string, default: 'PartnersController::zap_conciliacao'
  end
end
