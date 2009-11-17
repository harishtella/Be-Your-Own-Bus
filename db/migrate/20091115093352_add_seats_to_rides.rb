class AddSeatsToRides < ActiveRecord::Migration
  def self.up
    add_column :rides, :seats_total, :integer
    add_column :rides, :seats_available, :integer
  end

  def self.down
    remove_column :rides, :seats_total
    remove_column :rides, :seats_available
  end
end
