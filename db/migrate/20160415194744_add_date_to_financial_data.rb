class AddDateToFinancialData < ActiveRecord::Migration
  def change
    add_column :financial_data, :date, :datetime
  end
end
