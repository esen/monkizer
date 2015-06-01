class CreateBuildResults < ActiveRecord::Migration
  def change
    create_table :build_results do |t|
      t.integer :build_id
      t.integer :device_id
      t.boolean :passed
      t.string :log_file

      t.timestamps null: false
    end
  end
end
