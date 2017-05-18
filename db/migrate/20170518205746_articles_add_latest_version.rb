class ArticlesAddLatestVersion < ActiveRecord::Migration
  def change
    add_reference :papers, :version, column: :latest_version_id, index: true, foreign_key: true

    add_foreign_key :things_versions, :versions
  end
end
