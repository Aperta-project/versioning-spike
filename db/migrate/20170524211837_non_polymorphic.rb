class NonPolymorphic < ActiveRecord::Migration
  def change
    rename_table :things_versions, :versioned_answers
    remove_column :versioned_answers, :thing_type
    rename_column :versioned_answers, :thing_id, :answer_id
  end
end
