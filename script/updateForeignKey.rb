
Keyword.all.each |keyword| 
	Movie.all.each |movie|
		name = movie.name
		if name.include? keyword.keyword_phrase
			keyword.movie_id = movie.id
			keyword.save
		break
		end
	end
end