class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.belongs_to :movie, index: true
      t.string :keyword_phrase
      t.boolean :is_hash_tag

      t.timestamps null: false
    end
  end
end
