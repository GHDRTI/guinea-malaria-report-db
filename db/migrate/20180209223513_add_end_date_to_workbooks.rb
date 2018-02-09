class AddEndDateToWorkbooks < ActiveRecord::Migration
  def change
  	add_column :workbooks, :end_date, :datetime
  end
end
