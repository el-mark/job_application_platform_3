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

ActiveRecord::Schema[8.0].define(version: 2025_02_16_161911) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "alembic_version", primary_key: "version_num", id: { type: :string, limit: 32 }, force: :cascade do |t|
  end

  create_table "applicants", force: :cascade do |t|
    t.string "names"
    t.string "phone"
    t.text "work_experience"
    t.text "education"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article", id: :serial, force: :cascade do |t|
    t.string "title", limit: 510, null: false
    t.text "body", null: false
    t.string "image_url", limit: 255
    t.string "source", limit: 510
    t.string "source_name", limit: 64
    t.date "created_at", null: false
    t.integer "views", default: 0, null: false
    t.string "storage_file_name", limit: 255

    t.unique_constraint ["title"], name: "article_title_key"
  end

  create_table "comment", id: :serial, force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "user_id", null: false
    t.integer "article_id", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "recipient"
    t.string "sender"
    t.string "subject"
    t.json "json_raw_message"
  end

  create_table "events", force: :cascade do |t|
    t.integer "employee_id"
    t.datetime "timestamp", precision: nil
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "email_id"
    t.date "transaction_date", default: "2024-11-25"
    t.string "transaction_code"
    t.string "issuer"
    t.string "source"
    t.string "destination"
    t.integer "currency", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.integer "amount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "category"
    t.integer "frequency"
    t.text "description"
    t.index ["email_id"], name: "index_transactions_on_email_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user", id: :serial, force: :cascade do |t|
    t.string "email", limit: 150, null: false
    t.string "password_hash", limit: 255, null: false
    t.boolean "is_admin", null: false
    t.string "lastname", limit: 150
    t.string "name", limit: 150, null: false

    t.unique_constraint ["email"], name: "user_email_key"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comment", "article", name: "comment_article_id_fkey"
  add_foreign_key "comment", "user", name: "comment_user_id_fkey"
  add_foreign_key "transactions", "emails"
  add_foreign_key "transactions", "users"
end
