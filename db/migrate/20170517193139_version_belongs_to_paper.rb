class VersionBelongsToPaper < ActiveRecord::Migration
  def change
    add_reference :versions, :paper, index: true, foreign_key: true
  end
end
