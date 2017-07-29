class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.text :text
    end

    add_reference :versions, :text, index: true, null: false
  end
end
