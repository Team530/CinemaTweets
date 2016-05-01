class CreateGenreTags < ActiveRecord::Migration
  def change
    create_table :genre_tags do |t|
      t.belongs_to :genre, index: true
      t.belongs_to :movie, index: true
      t.timestamps null: false
    end
  end
end
