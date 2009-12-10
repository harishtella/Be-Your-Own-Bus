class AddSeatsFilledRemoveSeatsAvailable < ActiveRecord::Migration
  def self.up
    remove_column :rides, :seats_available
    add_column :rides, :seats_filled, :integer
  end

  def self.down
    remove_column :rides, :seats_filled
    add_column :rides, :seats_available, :integer
  end
end
