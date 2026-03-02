class CreateVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :versions do |t|
      t.references :document, null: false, foreign_key: true
      t.text :content
      t.boolean :ai_generated

      t.timestamps
    end
  end
end
