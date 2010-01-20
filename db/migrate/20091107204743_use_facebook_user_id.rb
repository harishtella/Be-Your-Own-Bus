class UseFacebookUserId < ActiveRecord::Migration
  def self.up
    remove_column :users, :name
    remove_column :users, :sex
    remove_column :users, :phonenumber
    remove_column :users, :email
    remove_column :users, :about
    add_column :users, :facebook_id, :integer, :null=>false,
    :default=>-1
    add_column :users, :session_key, :string
  end

  def self.down
    add_column :users, :name, :string
    add_column :users, :sex, :string
    add_column :users, :phonenumber, :string
    add_column :users, :email, :string
    add_column :users, :about, :text
    remove_column :users, :facebook_id
    remove_column :users, :session_key
  end
end
