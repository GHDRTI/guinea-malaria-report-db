class CreateWorkbookFiles < ActiveRecord::Migration
  def change
    create_table :workbook_files do |t|
      t.references :workbook, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :filename
      t.text :storage_url
      t.string :status
      t.datetime :uploaded_at
      t.json :import_overrides
      t.json :validation_errors
      t.json :import_errors

      t.timestamps null: false
    end
  end
end
