class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.text :name
      t.text :alternative_names, array: true, default: []

      t.timestamps null: false
    end
  end
end
