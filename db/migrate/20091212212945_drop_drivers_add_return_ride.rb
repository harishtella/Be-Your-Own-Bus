class DropDriversAddReturnRide < ActiveRecord::Migration
  def self.up
    drop_table :drivers
    remove_column :rides, :dropoff_datetime
    remove_column :rides, :dropoff
    add_column :rides, :return_ride, :boolean, :default => false 
    add_column :rides, :return_datetime, :datetime
  end

  def self.down
    
  end
end
