class Tweet < ActiveRecord::Base
	has_one :keyword
end
