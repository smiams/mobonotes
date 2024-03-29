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

ActiveRecord::Schema.define(:version => 20120714211924) do

  create_table "labels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "label_id"
    t.integer  "user_id"
    t.integer  "task_id"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "label_id"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "completed_at"
    t.datetime "due_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "rolling"
    t.datetime "irrelevant_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email_address"
    t.string   "password_hash"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
