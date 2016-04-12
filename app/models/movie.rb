class Movie < ActiveRecord::Base
	has_many :keywords
	has_many :financial_data
end
