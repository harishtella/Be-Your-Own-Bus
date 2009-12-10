class RemovePassengers < ActiveRecord::Migration
  def self.up
    drop_table :passengers 
    drop_table :passengers_rides
  end

  def self.down
  end
end
