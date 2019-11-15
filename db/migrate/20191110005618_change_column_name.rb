class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
  	rename_column :return_code_apis, :PartnerCode, :partner_code
  end
end
