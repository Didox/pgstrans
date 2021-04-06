class UnitelSequenceLog < ActiveRecord::Migration[5.2]
  def change
    add_column :unitel_sequences, :log, :text
  end
end
