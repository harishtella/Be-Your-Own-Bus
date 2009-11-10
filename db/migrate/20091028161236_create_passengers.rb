class CreatePassengers < ActiveRecord::Migration
  def self.up
    create_table :passengers do |t|
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :passengers
  end
end
