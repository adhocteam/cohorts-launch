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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170223211302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "person_id"
    t.integer  "submission_id"
    t.string   "value",         limit: 510
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "answers", ["person_id"], name: "answers_person_id_idx", using: :btree
  add_index "answers", ["question_id"], name: "answers_question_id_idx", using: :btree
  add_index "answers", ["submission_id"], name: "answers_submission_id_idx", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",       limit: 510, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.string   "commentable_type", limit: 510
    t.integer  "commentable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",                           default: 0, null: false
    t.integer  "attempts",                           default: 0, null: false
    t.text     "handler",                                        null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",              limit: 510
    t.string   "queue",                  limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delayed_reference_id"
    t.string   "delayed_reference_type", limit: 510
  end

  create_table "engagements", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "topic",        limit: 510, null: false
    t.date     "start_date"
    t.date     "end_date"
    t.text     "notes"
    t.text     "search_query"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "engagements", ["client_id"], name: "engagements_client_id_idx", using: :btree

  create_table "forms", force: :cascade do |t|
    t.string   "hash_id",     limit: 510
    t.string   "name",        limit: 510
    t.text     "description"
    t.string   "url",         limit: 510
    t.boolean  "hidden",                  default: false
    t.datetime "created_on"
    t.datetime "last_update"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "gift_cards", force: :cascade do |t|
    t.string   "gift_card_number", limit: 510
    t.string   "expiration_date",  limit: 510
    t.integer  "person_id"
    t.string   "notes",            limit: 510
    t.integer  "created_by"
    t.integer  "reason"
    t.integer  "amount_cents",                 default: 0,     null: false
    t.string   "amount_currency",  limit: 510, default: "USD", null: false
    t.integer  "giftable_id"
    t.string   "giftable_type",    limit: 510
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "batch_id",         limit: 510
    t.integer  "proxy_id"
  end

  create_table "mailchimp_exports", force: :cascade do |t|
    t.string   "name",       limit: 510
    t.text     "body"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailchimp_updates", force: :cascade do |t|
    t.text     "raw_content"
    t.string   "email",       limit: 510
    t.string   "update_type", limit: 510
    t.string   "reason",      limit: 510
    t.datetime "fired_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name",                       limit: 510
    t.string   "last_name",                        limit: 510
    t.string   "email_address",                    limit: 510
    t.string   "address_1",                        limit: 510
    t.string   "address_2",                        limit: 510
    t.string   "city",                             limit: 510
    t.string   "state",                            limit: 510
    t.string   "postal_code",                      limit: 510
    t.integer  "geography_id"
    t.integer  "primary_device_id"
    t.string   "primary_device_description",       limit: 510
    t.integer  "secondary_device_id"
    t.string   "secondary_device_description",     limit: 510
    t.integer  "primary_connection_id"
    t.string   "primary_connection_description",   limit: 510
    t.string   "phone_number",                     limit: 510
    t.string   "participation_type",               limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "signup_ip",                        limit: 510
    t.datetime "signup_at"
    t.integer  "secondary_connection_id"
    t.string   "secondary_connection_description", limit: 510
    t.string   "verified",                         limit: 510
    t.string   "preferred_contact_method",         limit: 510
    t.string   "token",                            limit: 510
    t.boolean  "active"
    t.datetime "deactivated_at"
    t.string   "deactivated_method",               limit: 510
    t.integer  "tag_count_cache",                              default: 0
  end

  create_table "questions", force: :cascade do |t|
    t.text     "text"
    t.string   "short_text",   limit: 510
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "form_id"
    t.string   "datatype",     limit: 510
    t.string   "field_id",     limit: 510
    t.datetime "version_date"
  end

  add_index "questions", ["form_id"], name: "questions_form_id_idx", using: :btree

  create_table "research_sessions", force: :cascade do |t|
    t.integer  "engagement_id"
    t.datetime "datetime",      null: false
    t.text     "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "research_sessions", ["engagement_id"], name: "research_sessions_engagement_id_idx", using: :btree

  create_table "session_invites", id: false, force: :cascade do |t|
    t.integer  "research_session_id", null: false
    t.integer  "person_id",           null: false
    t.boolean  "attended"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.text     "raw_content"
    t.integer  "person_id"
    t.string   "ip_addr",         limit: 510
    t.string   "entry_id",        limit: 510
    t.text     "form_structure"
    t.text     "field_structure"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form_type",                   default: 0
    t.integer  "form_id"
  end

  add_index "submissions", ["form_id"], name: "submissions_form_id_idx", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.string   "taggable_type", limit: 510
    t.integer  "taggable_id"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",           limit: 510
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "taggings_count",             default: 0, null: false
  end

  create_table "twilio_messages", force: :cascade do |t|
    t.string   "message_sid",        limit: 510
    t.datetime "date_created"
    t.datetime "date_updated"
    t.datetime "date_sent"
    t.string   "account_sid",        limit: 510
    t.string   "from",               limit: 510
    t.string   "to",                 limit: 510
    t.string   "body",               limit: 510
    t.string   "status",             limit: 510
    t.string   "error_code",         limit: 510
    t.string   "error_message",      limit: 510
    t.string   "direction",          limit: 510
    t.string   "from_city",          limit: 510
    t.string   "from_state",         limit: 510
    t.string   "from_zip",           limit: 510
    t.string   "wufoo_formid",       limit: 510
    t.integer  "conversation_count"
    t.string   "signup_verify",      limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twilio_wufoos", force: :cascade do |t|
    t.string   "name",           limit: 510
    t.string   "wufoo_formid",   limit: 510
    t.string   "twilio_keyword", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",                     null: false
    t.string   "end_message",    limit: 510
    t.string   "form_type",      limit: 510
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 510, default: "", null: false
    t.string   "encrypted_password",     limit: 510, default: "", null: false
    t.string   "reset_password_token",   limit: 510
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 510
    t.string   "last_sign_in_ip",        limit: 510
    t.string   "password_salt",          limit: 510
    t.string   "invitation_token",       limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",                                        null: false
    t.string   "name",                   limit: 510
    t.string   "token",                  limit: 510
    t.string   "phone_number",           limit: 510
  end

  create_table "v2_event_invitations", force: :cascade do |t|
    t.integer  "v2_event_id"
    t.string   "people_ids",  limit: 510
    t.string   "description", limit: 510
    t.string   "slot_length", limit: 510
    t.string   "date",        limit: 510
    t.string   "start_time",  limit: 510
    t.string   "end_time",    limit: 510
    t.integer  "buffer",                  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "title",       limit: 510
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 382, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 510, null: false
    t.string   "whodunnit",      limit: 510
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_foreign_key "answers", "people"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "submissions"
  add_foreign_key "engagements", "clients"
  add_foreign_key "questions", "forms"
  add_foreign_key "research_sessions", "engagements"
  add_foreign_key "submissions", "forms"
end
