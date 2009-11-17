class AddPriceToRides < ActiveRecord::Migration
  def self.up
    add_column :rides, :price, :string
  end

  def self.down
    remove_column :rides, :price
  end
end
