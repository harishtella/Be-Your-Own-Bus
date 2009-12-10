class AddDefaultForToCampusAndSeatsFilled < ActiveRecord::Migration
  def self.up
    change_column :rides, :seats_filled, :integer, :default => 0
    change_column :rides, :tocampus, :boolean, :default => false
  end

  def self.down
    change_column :rides, :seats_filled, :integer
    change_column :rides, :tocampus, :boolean
  end
end
