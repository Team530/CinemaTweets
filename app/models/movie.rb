class Movie < ActiveRecord::Base
	has_many :keywords
	has_many :financial_data

	has_many :genre_tags
	has_many :genres, through: :genre_tags
end
