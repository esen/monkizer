class AddVagrantIpToProject < ActiveRecord::Migration
  def change
    add_column :projects, :vagrant_ip, :string
  end
end
