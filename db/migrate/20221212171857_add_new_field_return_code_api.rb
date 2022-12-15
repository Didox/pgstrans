class AddNewFieldReturnCodeApi < ActiveRecord::Migration[5.2]
  def change
    add_column :return_code_apis, :codigo_erro_pagaso, :string
  end
end
