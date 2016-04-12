class CreateFinancialData < ActiveRecord::Migration
  def change
    create_table :financial_data do |t|
      t.integer :num_theaters
      t.decimal :gross_earnings
      t.belongs_to :movie, index: true
      t.timestamps null: false
    end
  end
end
