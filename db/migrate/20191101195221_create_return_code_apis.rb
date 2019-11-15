class CreateReturnCodeApis < ActiveRecord::Migration[5.2]
  def change
    create_table :return_code_apis do |t|
      t.string :return_code
      t.string :return_description
      t.string :error_description
      t.string :error_description_pt

      t.timestamps
    end
  end
end
