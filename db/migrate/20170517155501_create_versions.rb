class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :number

      t.timestamps null: false
    end
  end
end
