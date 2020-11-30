class LoopLogIndex < ActiveRecord::Migration[5.2]
  def change
    add_column :loop_logs, :index, :decimal
  end
end
