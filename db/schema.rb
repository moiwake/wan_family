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

ActiveRecord::Schema.define(version: 2023_05_29_045916) do

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "allowed_areas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "area", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["area"], name: "index_allowed_areas_on_area", unique: true
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "image_likes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "image_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["image_id"], name: "index_image_likes_on_image_id"
    t.index ["user_id", "blob_id"], name: "index_image_likes_on_user_id_and_blob_id", unique: true
    t.index ["user_id"], name: "index_image_likes_on_user_id"
  end

  create_table "images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "review_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "spot_id", null: false
    t.index ["review_id"], name: "index_images_on_review_id"
    t.index ["spot_id"], name: "index_images_on_spot_id"
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "impressions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", length: { params: 255 }
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: { message: 255 }
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "option_titles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_option_titles_on_name", unique: true
  end

  create_table "prefectures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_roma", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "region_id", null: false
    t.index ["name"], name: "unique_names", unique: true
    t.index ["name_roma"], name: "unique_name_romas", unique: true
    t.index ["region_id"], name: "index_prefectures_on_region_id"
  end

  create_table "regions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_roma", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_regions_on_name", unique: true
    t.index ["name_roma"], name: "index_regions_on_name_roma", unique: true
  end

  create_table "review_helpfulnesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "review_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["review_id"], name: "index_review_helpfulnesses_on_review_id"
    t.index ["user_id", "review_id"], name: "index_review_helpfulnesses_on_user_id_and_review_id", unique: true
    t.index ["user_id"], name: "index_review_helpfulnesses_on_user_id"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spot_id", null: false
    t.text "comment"
    t.integer "human_score", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "dog_score", null: false
    t.string "title", null: false
    t.date "visit_date", null: false
    t.integer "review_helpfulnesses_count", default: 0
    t.index ["spot_id"], name: "index_reviews_on_spot_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "rule_options", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "option_title_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_rule_options_on_name", unique: true
    t.index ["option_title_id"], name: "index_rule_options_on_option_title_id"
  end

  create_table "rules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.bigint "rule_option_id", null: false
    t.string "answer", default: "0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rule_option_id", "spot_id"], name: "index_rules_on_rule_option_id_and_spot_id", unique: true
    t.index ["rule_option_id"], name: "index_rules_on_rule_option_id"
    t.index ["spot_id"], name: "index_rules_on_spot_id"
  end

  create_table "spot_favorites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spot_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["spot_id"], name: "index_spot_favorites_on_spot_id"
    t.index ["user_id", "spot_id"], name: "index_spot_favorites_on_user_id_and_spot_id", unique: true
    t.index ["user_id"], name: "index_spot_favorites_on_user_id"
  end

  create_table "spot_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.bigint "user_id", null: false
    t.string "history", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["spot_id"], name: "index_spot_histories_on_spot_id"
    t.index ["user_id"], name: "index_spot_histories_on_user_id"
  end

  create_table "spot_tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", default: "行ってみたい", null: false
    t.text "memo"
    t.bigint "user_id", null: false
    t.bigint "spot_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["spot_id"], name: "index_spot_tags_on_spot_id"
    t.index ["user_id"], name: "index_spot_tags_on_user_id"
  end

  create_table "spots", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.float "latitude", limit: 53, null: false
    t.float "longitude", limit: 53, null: false
    t.string "address", null: false
    t.text "official_site"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "allowed_area_id", null: false
    t.bigint "category_id", null: false
    t.bigint "prefecture_id", null: false
    t.integer "impressions_count", default: 0
    t.integer "spot_favorites_count", default: 0
    t.index ["address"], name: "index_spots_on_address", unique: true
    t.index ["allowed_area_id"], name: "index_spots_on_allowed_area_id"
    t.index ["category_id"], name: "index_spots_on_category_id"
    t.index ["latitude", "longitude"], name: "index_spots_on_latitude_and_longitude", unique: true
    t.index ["name"], name: "index_spots_on_name", unique: true
    t.index ["prefecture_id"], name: "index_spots_on_prefecture_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.string "introduction"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "image_likes", "images"
  add_foreign_key "image_likes", "users"
  add_foreign_key "images", "reviews"
  add_foreign_key "images", "spots"
  add_foreign_key "images", "users"
  add_foreign_key "prefectures", "regions"
  add_foreign_key "review_helpfulnesses", "reviews"
  add_foreign_key "review_helpfulnesses", "users"
  add_foreign_key "reviews", "spots"
  add_foreign_key "reviews", "users"
  add_foreign_key "rule_options", "option_titles"
  add_foreign_key "rules", "rule_options"
  add_foreign_key "rules", "spots"
  add_foreign_key "spot_favorites", "spots"
  add_foreign_key "spot_favorites", "users"
  add_foreign_key "spot_histories", "spots"
  add_foreign_key "spot_histories", "users"
  add_foreign_key "spot_tags", "spots"
  add_foreign_key "spot_tags", "users"
  add_foreign_key "spots", "allowed_areas"
  add_foreign_key "spots", "categories"
  add_foreign_key "spots", "prefectures"
end
