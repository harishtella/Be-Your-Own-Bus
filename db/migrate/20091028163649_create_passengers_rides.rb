class CreatePassengersRides < ActiveRecord::Migration
  def self.up
    create_table :passengers_rides, :id => false do |t|
      t.integer :passenger_id, :null => false
      t.integer :ride_id, :null => false
    end

    add_index :passengers_rides, [:passenger_id, :ride_id], :unique => true 
  end

  def self.down
    remove_index :passengers_rides, :column => [:passenger_id, :ride_id] 
    drop_table :passengers_rides
  end
end
