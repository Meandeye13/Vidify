# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120506205145) do

  create_table "group_members", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.integer  "ownerid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["user_id"], :name => "index_users_on_user_id", :unique => true

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "src_url"
    t.string   "post_id"
    t.string   "img_src"
    t.integer  "group_id"
  end

  add_index "videos", ["post_id"], :name => "index_videos_on_post_id", :unique => true
  add_index "videos", ["user_id", "created_time"], :name => "index_videos_on_user_id_and_created_time"

end
