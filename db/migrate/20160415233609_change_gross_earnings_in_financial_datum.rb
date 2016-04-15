class ChangeGrossEarningsInFinancialDatum < ActiveRecord::Migration
  def change
     add_column :financial_data, :daily_gross, :int
     change_column :financial_data, :gross_earnings, :int
  end
end
