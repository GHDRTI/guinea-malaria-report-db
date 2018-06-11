class AddEndDateToHealthFacility < ActiveRecord::Migration
  def change
  	add_column :health_facilities, :end_date, :datetime
  end
end
