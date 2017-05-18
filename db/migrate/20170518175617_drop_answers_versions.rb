class DropAnswersVersions < ActiveRecord::Migration
  def change
    drop_table :versions_answers
  end
end
