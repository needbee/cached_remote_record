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

ActiveRecord::Schema.define(:version => 20120615123707) do

  create_table "app_devices", :force => true do |t|
    t.integer  "app_id"
    t.integer  "device_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.decimal  "price"
    t.integer  "file_size_bytes"
    t.datetime "release_date"
    t.string   "category"
    t.string   "company_name"
    t.text     "description"
    t.text     "release_notes"
    t.string   "company_url"
    t.string   "icon_url"
    t.string   "itunes_link"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "api_key"
    t.integer  "itunes_rating"
  end

  create_table "device_lines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "device_line_id"
  end

  create_table "supported_device_codes", :force => true do |t|
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "device_id"
  end

end
