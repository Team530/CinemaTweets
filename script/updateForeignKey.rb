
Keyword.all.each do |keyword| 
	puts "keyword"
	Movie.all.each do |movie|
		name = movie.name
		if name.include? keyword.keyword_phrase
			keyword.movie_id = movie.id
			keyword.save
			puts "update"
		break
		end
	end
end