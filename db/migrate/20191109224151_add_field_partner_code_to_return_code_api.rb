class AddFieldPartnerCodeToReturnCodeApi < ActiveRecord::Migration[5.2]
  def change
    add_column :return_code_apis, :PartnerCode, :integer
  end
end
