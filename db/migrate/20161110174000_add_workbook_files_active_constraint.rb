class AddWorkbookFilesActiveConstraint < ActiveRecord::Migration
  def change
    add_index :workbook_files, [:workbook_id], unique: true, 
      name: 'index_workbook_files_unique_active', where: "status = 'active'"
  end
end