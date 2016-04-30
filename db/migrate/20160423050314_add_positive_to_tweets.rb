class AddPositiveToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :positive, :integer
  end
end
