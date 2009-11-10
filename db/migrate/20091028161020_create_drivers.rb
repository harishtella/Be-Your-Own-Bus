class CreateDrivers < ActiveRecord::Migration
  def self.up
    create_table :drivers do |t|
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :drivers
  end
end
