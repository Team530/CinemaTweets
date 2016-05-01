class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.integer :count
      t.string :genre_name

      t.timestamps null: false
    end
  end
end
