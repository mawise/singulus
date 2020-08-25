# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_25_191147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "resource_type"
    t.uuid "resource_id"
    t.text "name", null: false
    t.text "target_url", null: false
    t.text "title"
    t.text "tags", default: [], null: false, array: true
    t.integer "expires_in"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_links_on_name", unique: true
    t.index ["resource_id", "resource_type"], name: "index_links_on_resource_id_and_resource_type"
    t.index ["resource_type", "resource_id"], name: "index_links_on_resource_type_and_resource_id"
    t.index ["tags"], name: "index_links_on_tags", using: :gin
    t.index ["target_url"], name: "index_links_on_target_url"
  end

  create_table "oauth_access_grants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "resource_owner_id", null: false
    t.uuid "application_id", null: false
    t.text "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.text "scopes", default: "", null: false
    t.text "code_challenge"
    t.text "code_challenge_method"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "resource_owner_id"
    t.uuid "application_id", null: false
    t.text "token", null: false
    t.text "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.text "scopes"
    t.text "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name", null: false
    t.text "uid", null: false
    t.text "secret", null: false
    t.text "redirect_uri"
    t.text "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "url"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
    t.index ["url"], name: "index_oauth_applications_on_url", unique: true
  end

  create_table "photos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "post_id"
    t.text "alt"
    t.interval "duration"
    t.hstore "metadata", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "file_data"
    t.index ["metadata"], name: "index_photos_on_metadata", using: :gin
    t.index ["post_id"], name: "index_photos_on_post_id"
  end

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "author_id", null: false
    t.text "content"
    t.datetime "published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "short_uid"
    t.text "name"
    t.text "summary"
    t.text "url"
    t.text "categories", default: [], array: true
    t.text "slug"
    t.jsonb "properties", default: "{}", null: false
    t.jsonb "location"
    t.integer "rsvp"
    t.jsonb "in_reply_to"
    t.jsonb "like_of"
    t.jsonb "repost_of"
    t.jsonb "bookmark_of"
    t.text "syndications", array: true
    t.text "content_html"
    t.text "type"
    t.uuid "featured_id"
    t.text "og_title"
    t.text "og_url"
    t.text "og_image"
    t.text "og_type"
    t.text "og_description"
    t.text "og_locale"
    t.text "twitter_card"
    t.text "twitter_creator"
    t.text "twitter_creator_id"
    t.text "twitter_site"
    t.text "twitter_site_id"
    t.text "twitter_title"
    t.text "twitter_description"
    t.text "twitter_image"
    t.text "twitter_image_alt"
    t.text "twitter_player"
    t.integer "twitter_player_width"
    t.integer "twitter_player_height"
    t.text "twitter_player_stream"
    t.text "meta_description"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["bookmark_of"], name: "index_posts_on_bookmark_of", using: :gin
    t.index ["categories"], name: "index_posts_on_categories", using: :gin
    t.index ["featured_id"], name: "index_posts_on_featured_id"
    t.index ["in_reply_to"], name: "index_posts_on_in_reply_to", using: :gin
    t.index ["like_of"], name: "index_posts_on_like_of", using: :gin
    t.index ["location"], name: "index_posts_on_location", using: :gin
    t.index ["properties"], name: "index_posts_on_properties", using: :gin
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["repost_of"], name: "index_posts_on_repost_of", using: :gin
    t.index ["rsvp"], name: "index_posts_on_rsvp"
    t.index ["short_uid"], name: "index_posts_on_short_uid", unique: true
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["syndications"], name: "index_posts_on_syndications", using: :gin
    t.index ["type"], name: "index_posts_on_type"
    t.index ["url"], name: "index_posts_on_url"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.text "profile_url"
    t.text "twitter_user_id"
    t.text "twitter_username"
    t.uuid "photo_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["photo_id"], name: "index_users_on_photo_id"
    t.index ["profile_url"], name: "index_users_on_profile_url"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "webmentions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "short_uid", null: false
    t.uuid "source_id"
    t.text "source_url", null: false
    t.jsonb "source_properties", default: {}, null: false
    t.uuid "target_id"
    t.text "target_url", null: false
    t.datetime "verified_at"
    t.datetime "approved_at"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "status", default: "pending", null: false
    t.jsonb "status_info", default: {}, null: false
    t.datetime "received_at"
    t.datetime "sent_at"
    t.index ["received_at"], name: "index_webmentions_on_received_at"
    t.index ["sent_at"], name: "index_webmentions_on_sent_at"
    t.index ["source_id", "target_id"], name: "index_webmentions_on_source_id_and_target_id", unique: true
    t.index ["source_id"], name: "index_webmentions_on_source_id"
    t.index ["source_properties"], name: "index_webmentions_on_source_properties", using: :gin
    t.index ["source_url", "target_id"], name: "index_webmentions_on_source_url_and_target_id", unique: true
    t.index ["source_url", "target_url"], name: "index_webmentions_on_source_url_and_target_url", unique: true
    t.index ["status"], name: "index_webmentions_on_status"
    t.index ["target_id"], name: "index_webmentions_on_target_id"
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "posts", "photos", column: "featured_id"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "users", "photos"
  add_foreign_key "webmentions", "posts", column: "source_id"
  add_foreign_key "webmentions", "posts", column: "target_id"
end
