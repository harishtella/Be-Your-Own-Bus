class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :sex
      t.string :phonenumber
      t.string :email
      t.text :about

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
