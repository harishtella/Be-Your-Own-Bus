class AddReturnRideIdDropReturnDatetime < ActiveRecord::Migration
  def self.up
    remove_column :rides, :return_datetime
    add_column :rides, :return_ride_id, :integer 
  end

  def self.down
  end
end
