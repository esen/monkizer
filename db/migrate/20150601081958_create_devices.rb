class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :model
      t.string :version
      t.string :adb_device_id
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
