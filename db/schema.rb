# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091215021437) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ride_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["ride_id", "created_at"], :name => "index_comments_on_ride_id_and_created_at"

  create_table "facebook_templates", :force => true do |t|
    t.string "template_name", :null => false
    t.string "content_hash",  :null => false
    t.string "bundle_id"
  end

  add_index "facebook_templates", ["template_name"], :name => "index_facebook_templates_on_template_name", :unique => true

  create_table "riderships", :force => true do |t|
    t.integer  "ride_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rides", :force => true do |t|
    t.string   "name"
    t.boolean  "tocampus",       :default => false
    t.text     "about"
    t.integer  "driver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "price"
    t.integer  "seats_total"
    t.integer  "seats_filled",   :default => 0
    t.boolean  "return_ride",    :default => false
    t.datetime "start_datetime"
    t.string   "place"
    t.integer  "origin_ride_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_id", :limit => 20, :null => false
    t.string   "session_key"
  end

  create_table "watcherships", :force => true do |t|
    t.integer  "ride_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
