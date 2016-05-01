class Genre < ActiveRecord::Base
   has_many :genre_tags
   has_many :movies, through: :genre_tags
end
