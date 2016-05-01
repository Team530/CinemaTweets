class CreateTweetPerMovies < ActiveRecord::Migration
  def change
    create_table :tweet_per_movies do |t|
      t.integer :number_of_favorites
      t.integer :number_of_retweets
      t.integer :number_of_tweets
      t.datetime :date
      t.integer :positive
      t.integer :negative

      t.timestamps null: false
    end
  end
end
