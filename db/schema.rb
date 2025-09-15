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

ActiveRecord::Schema[7.2].define(version: 2025_09_14_140316) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "badges", force: :cascade do |t|
    t.string "name", null: false
    t.integer "badge_kind", null: false
    t.integer "threshold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_kind", "threshold"], name: "index_badges_on_badge_kind_and_threshold"
    t.index ["name"], name: "index_badges_on_name"
    t.index ["threshold"], name: "index_badges_on_threshold"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_bookmarks_on_product_id"
    t.index ["user_id", "product_id"], name: "index_bookmarks_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "post_sweetness_scores", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.integer "sweetness_strength", null: false
    t.integer "aftertaste_clarity", null: false
    t.integer "natural_sweetness", null: false
    t.integer "coolness", null: false
    t.integer "richness", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_sweetness_scores_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "sweetness_rating", null: false
    t.text "review"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id", null: false
    t.index ["product_id"], name: "index_posts_on_product_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "name", null: false
    t.string "manufacturer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name", "manufacturer"], name: "index_products_on_name_and_manufacturer", unique: true
  end

  create_table "sweetness_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "sweetness_strength"
    t.integer "aftertaste_clarity"
    t.integer "natural_sweetness"
    t.integer "coolness"
    t.integer "richness"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sweetness_type_id", null: false
    t.string "token", null: false
    t.index ["sweetness_type_id"], name: "index_sweetness_profiles_on_sweetness_type_id"
    t.index ["token"], name: "index_sweetness_profiles_on_token", unique: true
    t.index ["user_id"], name: "index_sweetness_profiles_on_user_id"
  end

  create_table "sweetness_twins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "twin_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twin_user_id"], name: "index_sweetness_twins_on_twin_user_id"
    t.index ["user_id"], name: "index_sweetness_twins_on_user_id"
  end

  create_table "sweetness_types", force: :cascade do |t|
    t.integer "sweetness_kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_badges", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "badge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_user_badges_on_badge_id"
    t.index ["user_id", "badge_id"], name: "index_user_badges_on_user_id_and_badge_id", unique: true
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.bigint "sweetness_type_id"
    t.string "self_introduction"
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["sweetness_type_id"], name: "index_users_on_sweetness_type_id"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "products"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "post_sweetness_scores", "posts"
  add_foreign_key "posts", "products"
  add_foreign_key "posts", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "sweetness_profiles", "sweetness_types"
  add_foreign_key "sweetness_profiles", "users"
  add_foreign_key "sweetness_twins", "users"
  add_foreign_key "sweetness_twins", "users", column: "twin_user_id"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
  add_foreign_key "users", "sweetness_types"
end
