class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :project_id
      t.string :ci_build_number

      t.timestamps null: false
    end
  end
end
