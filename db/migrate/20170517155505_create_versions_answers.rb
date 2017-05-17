class CreateVersionsAnswers < ActiveRecord::Migration
  def change
    create_table :versions_answers do |t|
      t.references :answer, index: true, foreign_key: true
      t.references :version, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
