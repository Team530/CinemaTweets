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

ActiveRecord::Schema.define(version: 20160501092549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "financial_data", force: :cascade do |t|
    t.integer  "num_theaters"
    t.integer  "gross_earnings"
    t.integer  "movie_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "date"
    t.integer  "daily_gross"
  end

  add_index "financial_data", ["movie_id"], name: "index_financial_data_on_movie_id", using: :btree

  create_table "genre_tags", force: :cascade do |t|
    t.integer  "genre_id"
    t.integer  "movie_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "genre_tags", ["genre_id"], name: "index_genre_tags_on_genre_id", using: :btree
  add_index "genre_tags", ["movie_id"], name: "index_genre_tags_on_movie_id", using: :btree

  create_table "genres", force: :cascade do |t|
    t.integer  "count"
    t.string   "genre_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.integer  "movie_id"
    t.string   "keyword_phrase"
    t.boolean  "is_hash_tag"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "keywords", ["movie_id"], name: "index_keywords_on_movie_id", using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "name"
    t.datetime "release_date"
    t.string   "MPAA_rating"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "budget",       default: -1
  end

  create_table "tweet_per_movies", force: :cascade do |t|
    t.integer  "number_of_favorites"
    t.integer  "number_of_retweets"
    t.integer  "number_of_tweets"
    t.datetime "date"
    t.integer  "positive"
    t.integer  "negative"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.integer  "number_of_favorites"
    t.integer  "number_of_retweets"
    t.integer  "number_of_tweets"
    t.integer  "keyword_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "date"
    t.integer  "positive"
    t.integer  "negative"
  end

  add_index "tweets", ["keyword_id"], name: "index_tweets_on_keyword_id", using: :btree

end
