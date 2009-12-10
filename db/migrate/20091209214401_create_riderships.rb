class CreateRiderships < ActiveRecord::Migration
  def self.up
    create_table :riderships do |t|
      t.integer :ride_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :riderships
  end
end
