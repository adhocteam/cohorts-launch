class CohortsMassacre < ActiveRecord::Migration
  def change
    drop_table "applications", force: :cascade do |t|
      t.string   "name",         limit: 255
      t.text     "description",  limit: 65535
      t.string   "url",          limit: 255
      t.string   "source_url",   limit: 255
      t.string   "creator_name", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "program_id",   limit: 4
      t.integer  "created_by",   limit: 4
      t.integer  "updated_by",   limit: 4
    end

    drop_table "events", force: :cascade do |t|
      t.string   "name",           limit: 255
      t.text     "description",    limit: 65535
      t.datetime "starts_at"
      t.datetime "ends_at"
      t.text     "location",       limit: 65535
      t.text     "address",        limit: 65535
      t.integer  "capacity",       limit: 4
      t.integer  "application_id", limit: 4
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "created_by",     limit: 4
      t.integer  "updated_by",     limit: 4
    end

    drop_table "invitation_invitees_join_table", force: :cascade do |t|
      t.integer  "person_id",           limit: 4
      t.integer  "event_invitation_id", limit: 4
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
    end

    drop_table "programs", force: :cascade do |t|
      t.string   "name",        limit: 255
      t.text     "description", limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "created_by",  limit: 4
      t.integer  "updated_by",  limit: 4
    end

    drop_table "reservations", force: :cascade do |t|
      t.integer  "person_id",    limit: 4
      t.integer  "event_id",     limit: 4
      t.datetime "confirmed_at"
      t.integer  "created_by",   limit: 4
      t.datetime "attended_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "updated_by",   limit: 4
    end

    drop_table "v2_events", force: :cascade do |t|
      t.integer  "user_id",     limit: 4
      t.string   "description", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    drop_table "v2_reservations", force: :cascade do |t|
      t.integer  "time_slot_id",        limit: 4
      t.integer  "person_id",           limit: 4
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id",             limit: 4
      t.integer  "event_id",            limit: 4
      t.integer  "event_invitation_id", limit: 4
      t.string   "aasm_state",          limit: 255
    end

    drop_table "v2_time_slots", force: :cascade do |t|
      t.integer  "event_id",   limit: 4
      t.datetime "start_time"
      t.datetime "end_time"
    end
  end
end
