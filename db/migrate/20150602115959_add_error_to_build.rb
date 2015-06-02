class AddErrorToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :error, :string
  end
end
