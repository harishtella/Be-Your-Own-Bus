class DropReturnRideIdAddOriginRideId < ActiveRecord::Migration
  def self.up
    remove_column :rides, :return_ride_id
    add_column :rides, :origin_ride_id, :integer
  end

  def self.down
  end
end
