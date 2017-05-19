class ThingsVersionsRemoveTimestamps < ActiveRecord::Migration
  def change
    remove_column :things_versions, :updated_at
    remove_column :things_versions, :created_at
  end
end
