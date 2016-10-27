class CreateHealthFacilities < ActiveRecord::Migration
  def change
    create_table :health_facilities do |t|
      t.references :district, index: true, foreign_key: true
      t.text :name
      t.text :alternative_names, array: true, default: []
      t.text :location

      t.timestamps null: false
    end
  end
end
