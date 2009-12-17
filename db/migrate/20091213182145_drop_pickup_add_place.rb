class DropPickupAddPlace < ActiveRecord::Migration
  def self.up
    remove_column :rides, :pickup
    add_column :rides, :place, :string
  end

  def self.down
  end
end
