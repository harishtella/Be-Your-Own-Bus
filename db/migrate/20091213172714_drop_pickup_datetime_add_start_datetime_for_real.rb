class DropPickupDatetimeAddStartDatetimeForReal < ActiveRecord::Migration
  def self.up
    remove_column :rides, :pickup_datetime
    add_column :rides, :start_datetime, :datetime
  end

  def self.down
  end
end
