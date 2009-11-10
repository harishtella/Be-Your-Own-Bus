class AddDatesToRides < ActiveRecord::Migration
  def self.up
    add_column :rides, :pickup_datetime, :datetime
    add_column :rides, :dropoff_datetime, :datetime
  end

  def self.down
    remove_column :rides, :pickup_datetime
    remove_column :rides, :dropoff_datetime
  end
end
