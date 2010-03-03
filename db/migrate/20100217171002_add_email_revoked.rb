class AddEmailRevoked < ActiveRecord::Migration
  def self.up
    add_column :users, :email_revoked, :boolean, :default => false
  end

  def self.down
    remove_column :users, :email_revoked
  end
end
