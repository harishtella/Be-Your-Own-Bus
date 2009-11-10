class CreateRides < ActiveRecord::Migration
  def self.up
    create_table :rides do |t|
      t.string :name
      t.string :pickup
      t.string :dropoff
      t.boolean :tocampus
      t.text :about
      t.references :driver

      t.timestamps
    end
  end

  def self.down
    drop_table :rides
  end
end
