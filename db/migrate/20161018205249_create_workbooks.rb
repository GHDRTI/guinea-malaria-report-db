class CreateWorkbooks < ActiveRecord::Migration
  def change
    create_table :workbooks do |t|
      t.references :district, index: true, foreign_key: true
      t.integer :reporting_month
      t.integer :reporting_year

      t.timestamps null: false
    end
  end
end
