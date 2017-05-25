class AddIndexes < ActiveRecord::Migration
  def change
    add_index :versioned_answers, :answer_id
    add_index :versioned_answers, :version_id
  end
end
