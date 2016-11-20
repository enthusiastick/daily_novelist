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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161120043049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drabbles", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "word_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_drabbles_on_user_id", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_identities_on_uid", unique: true, using: :btree
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "confirmation_digest"
    t.datetime "confirmed_at"
    t.string   "email",                                    null: false
    t.string   "first_name",                               null: false
    t.string   "handle",                                   null: false
    t.string   "last_name",                                null: false
    t.string   "password_digest"
    t.string   "password_reset_digest"
    t.datetime "password_reset_sent_at"
    t.string   "remember_digest"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "reminder_active",        default: true
    t.string   "reminder_time",          default: "12:00"
    t.string   "time_zone"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["handle"], name: "index_users_on_handle", unique: true, using: :btree
  end

end
