class PapersRenameVersionId < ActiveRecord::Migration
  def change
    rename_column :papers, :version_id, :latest_version_id
  end
end
