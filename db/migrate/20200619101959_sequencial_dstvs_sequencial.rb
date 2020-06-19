class SequencialDstvsSequencial < ActiveRecord::Migration[5.2]
  def change
    add_column :sequencial_dstvs, :request_body, :text
    add_column :sequencial_dstvs, :response_body, :text
  end
end
