class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :logon 
      t.string  :first_name
      t.string  :last_name
      t.string  :spectrum_number
      t.string  :password
      t.boolean :admin, :default => false

      t.timestamps
    end

    create_table :conference_numbers do |t|
      t.string :conference_number

      t.timestamps
    end

    create_table :bookings do |t|
      t.integer :conference_number_id
      t.integer :user_id
      t.date :date
      t.time :time_start
      t.time :time_finish

      t.timestamps
    end
    
    def down
      drop_table :users
      drop_table :conference_numbers
      drop_table :bookings
    end
    
  end
end
