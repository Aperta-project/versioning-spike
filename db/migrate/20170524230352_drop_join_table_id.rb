class DropJoinTableId < ActiveRecord::Migration
  def change
    remove_column :versioned_answers, :id
  end
end
