class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :name
      t.text :email
      t.string :login_key
      t.datetime :login_key_expires
      t.datetime :last_login_time
      t.string :last_login_ip

      t.timestamps null: false
    end
  end
end
