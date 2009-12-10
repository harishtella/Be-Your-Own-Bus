class CreateWatcherships < ActiveRecord::Migration
  def self.up
    create_table :watcherships do |t|
      t.column :ride_id, :integer
      t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :watcherships
  end
end
