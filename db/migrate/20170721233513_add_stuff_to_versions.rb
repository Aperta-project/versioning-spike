class AddStuffToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :title, :text
    add_column :versions, :abstract, :text
  end
end
