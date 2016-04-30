class AddNegativeToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :negative, :integer
  end
end
