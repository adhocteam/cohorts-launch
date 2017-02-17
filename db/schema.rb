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

ActiveRecord::Schema.define(version: 20170215163504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "person_id"
    t.integer  "submission_id"
    t.string   "value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "answers", ["person_id"], name: "index_answers_on_person_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["submission_id"], name: "index_answers_on_submission_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delayed_reference_id"
    t.string   "delayed_reference_type"
  end

  add_index "delayed_jobs", ["delayed_reference_type"], name: "delayed_jobs_delayed_reference_type", using: :btree
  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  add_index "delayed_jobs", ["queue"], name: "delayed_jobs_queue", using: :btree

  create_table "engagements", force: :cascade do |t|
    t.integer  "client_id"
    t.string   "topic",        null: false
    t.date     "start_date"
    t.date     "end_date"
    t.text     "notes"
    t.text     "search_query"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "engagements", ["client_id"], name: "index_engagements_on_client_id", using: :btree

  create_table "forms", force: :cascade do |t|
    t.string   "hash_id"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.boolean  "hidden",      default: false
    t.datetime "created_on"
    t.datetime "last_update"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "gift_cards", force: :cascade do |t|
    t.string   "gift_card_number"
    t.string   "expiration_date"
    t.integer  "person_id"
    t.string   "notes"
    t.integer  "created_by"
    t.integer  "reason"
    t.integer  "amount_cents",     default: 0,     null: false
    t.string   "amount_currency",  default: "USD", null: false
    t.integer  "giftable_id"
    t.string   "giftable_type"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "batch_id"
    t.integer  "proxy_id"
  end

  add_index "gift_cards", ["giftable_type", "giftable_id"], name: "index_gift_cards_on_giftable_type_and_giftable_id", using: :btree
  add_index "gift_cards", ["reason"], name: "gift_reason_index", using: :btree

  create_table "mailchimp_exports", force: :cascade do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailchimp_updates", force: :cascade do |t|
    t.text     "raw_content"
    t.string   "email"
    t.string   "update_type"
    t.string   "reason"
    t.datetime "fired_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.integer  "geography_id"
    t.integer  "primary_device_id"
    t.string   "primary_device_description"
    t.integer  "secondary_device_id"
    t.string   "secondary_device_description"
    t.integer  "primary_connection_id"
    t.string   "primary_connection_description"
    t.string   "phone_number"
    t.string   "participation_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "signup_ip"
    t.datetime "signup_at"
    t.string   "voted"
    t.integer  "secondary_connection_id"
    t.string   "secondary_connection_description"
    t.string   "verified"
    t.string   "preferred_contact_method"
    t.string   "token"
    t.boolean  "active",                           default: true
    t.datetime "deactivated_at"
    t.string   "deactivated_method"
    t.integer  "tag_count_cache",                  default: 0
    t.string   "contact_representative"
  end

  create_table "questions", force: :cascade do |t|
    t.text     "text"
    t.string   "short_text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "form_id"
    t.string   "datatype"
    t.string   "field_id"
    t.datetime "version_date"
  end

  create_table "research_sessions", force: :cascade do |t|
    t.integer  "engagement_id"
    t.datetime "datetime",      null: false
    t.text     "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "research_sessions", ["engagement_id"], name: "index_research_sessions_on_engagement_id", using: :btree

  create_table "session_invites", id: false, force: :cascade do |t|
    t.integer  "research_session_id", null: false
    t.integer  "person_id",           null: false
    t.boolean  "attended"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "session_invites", ["person_id"], name: "index_session_invites_on_person_id", using: :btree
  add_index "session_invites", ["research_session_id"], name: "index_session_invites_on_research_session_id", using: :btree

  create_table "submissions", force: :cascade do |t|
    t.text     "raw_content"
    t.integer  "person_id"
    t.string   "ip_addr"
    t.string   "entry_id"
    t.text     "form_structure"
    t.text     "field_structure"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form_type",       default: 0
    t.integer  "form_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "taggings_count", default: 0, null: false
  end

  create_table "twilio_messages", force: :cascade do |t|
    t.string   "message_sid"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.datetime "date_sent"
    t.string   "account_sid"
    t.string   "from"
    t.string   "to"
    t.string   "body"
    t.string   "status"
    t.string   "error_code"
    t.string   "error_message"
    t.string   "direction"
    t.string   "from_city"
    t.string   "from_state"
    t.string   "from_zip"
    t.string   "wufoo_formid"
    t.integer  "conversation_count"
    t.string   "signup_verify"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twilio_wufoos", force: :cascade do |t|
    t.string   "name"
    t.string   "wufoo_formid"
    t.string   "twilio_keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",         default: false, null: false
    t.string   "end_message"
    t.string   "form_type"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "invitation_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",               default: false, null: false
    t.string   "name"
    t.string   "token"
    t.string   "phone_number"
  end

  create_table "v2_event_invitations", force: :cascade do |t|
    t.integer  "v2_event_id"
    t.string   "people_ids"
    t.string   "description"
    t.string   "slot_length"
    t.string   "date"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "buffer",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "title"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "answers", "people"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "submissions"
  add_foreign_key "engagements", "clients"
  add_foreign_key "questions", "forms"
  add_foreign_key "research_sessions", "engagements"
  add_foreign_key "submissions", "forms"
end
