class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :number_of_favorites
      t.integer :number_of_retweets
      t.integer :number_of_tweets
      t.belongs_to :keyword, index: true
      t.timestamps null: false
    end
  end
end
