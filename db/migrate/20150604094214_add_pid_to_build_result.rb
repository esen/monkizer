class AddPidToBuildResult < ActiveRecord::Migration
  def change
    add_column :build_results, :pid, :integer
  end
end
