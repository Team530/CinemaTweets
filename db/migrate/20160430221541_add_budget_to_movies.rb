class AddBudgetToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :budget, :int, :default => -1
  end
end
