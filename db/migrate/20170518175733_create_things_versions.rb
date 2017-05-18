class CreateThingsVersions < ActiveRecord::Migration
  def change
    create_table :things_versions do |t|
      t.references :version
      t.references :thing, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
