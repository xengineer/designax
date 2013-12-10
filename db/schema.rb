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

ActiveRecord::Schema.define(:version => 20131203070000) do

  create_table "corp_states", :force => true do |t|
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "design_data", :force => true do |t|
    t.integer  "project_id"
    t.string   "file_name"
    t.integer  "curSeq_id"
    t.binary   "thumbnail",      :limit => 16777215
    t.string   "ctype"
    t.date     "up_date"
    t.string   "designer"
    t.string   "chara_name"
    t.integer  "state_id"
    t.integer  "corp_state_id"
    t.string   "design_comment"
    t.string   "corp_comment"
    t.date     "deadline"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.boolean  "delflag",                            :default => false
  end

  add_index "design_data", ["corp_state_id"], :name => "index_design_data_on_corp_state_id"
  add_index "design_data", ["project_id", "file_name"], :name => "index_design_data_on_project_id_and_file_name", :unique => true
  add_index "design_data", ["project_id"], :name => "index_design_data_on_project_id"
  add_index "design_data", ["state_id"], :name => "index_design_data_on_state_id"

  create_table "image_data", :force => true do |t|
    t.integer  "project_id"
    t.integer  "designdata_id_id"
    t.integer  "seq_id"
    t.binary   "image",            :limit => 16777215
    t.string   "ctype"
    t.string   "file_name"
    t.binary   "thumbnail",        :limit => 16777215
    t.date     "up_date"
    t.integer  "state_id"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.boolean  "delflag",                              :default => false
  end

  add_index "image_data", ["designdata_id_id"], :name => "index_image_data_on_designdata_id_id"
  add_index "image_data", ["project_id", "file_name", "seq_id"], :name => "index_image_data_on_project_id_and_file_name_and_seq_id", :unique => true
  add_index "image_data", ["project_id"], :name => "index_image_data_on_project_id"
  add_index "image_data", ["state_id"], :name => "index_image_data_on_state_id"

  create_table "projects", :force => true do |t|
    t.string   "project_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_infos", :force => true do |t|
    t.string   "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_projects", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "role"
    t.string   "username"
    t.integer  "user_group_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
