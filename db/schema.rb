# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_11_010859) do
  create_table "attributions", force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.string "event_type", null: false
    t.datetime "timestamp", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_attributions_on_campaign_id"
    t.index ["contact_id"], name: "index_attributions_on_contact_id"
    t.index ["event_type"], name: "index_attributions_on_event_type"
    t.index ["timestamp"], name: "index_attributions_on_timestamp"
  end

  create_table "audience_contacts", force: :cascade do |t|
    t.integer "audience_id", null: false
    t.integer "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audience_id"], name: "index_audience_contacts_on_audience_id"
    t.index ["contact_id"], name: "index_audience_contacts_on_contact_id"
  end

  create_table "audiences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "campaign_audiences", force: :cascade do |t|
    t.integer "audience_id", null: false
    t.integer "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audience_id"], name: "index_campaign_audiences_on_audience_id"
    t.index ["campaign_id"], name: "index_campaign_audiences_on_campaign_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.decimal "budget"
    t.string "channel"
    t.datetime "created_at", null: false
    t.string "external_id"
    t.string "name"
    t.string "objective"
    t.string "status", default: "draft"
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "age_range"
    t.string "company"
    t.datetime "created_at", null: false
    t.string "education_level"
    t.string "email"
    t.string "family_status"
    t.string "first_name"
    t.string "gender"
    t.string "income_range"
    t.string "job_title"
    t.string "last_name"
    t.string "marital_status"
    t.string "occupation"
    t.datetime "updated_at", null: false
  end

  create_table "insights", force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.integer "clicks"
    t.integer "conversions"
    t.datetime "created_at", null: false
    t.integer "impressions"
    t.decimal "spend"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_insights_on_campaign_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "audience_contacts", "audiences"
  add_foreign_key "audience_contacts", "contacts"
  add_foreign_key "campaign_audiences", "audiences"
  add_foreign_key "campaign_audiences", "campaigns"
  add_foreign_key "insights", "campaigns"
end
