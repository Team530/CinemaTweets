class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.datetime :release_date
      t.string :genre
      t.string :MPAA_rating

      t.timestamps null: false
    end
  end
end
