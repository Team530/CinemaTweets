def parseString1(title)
    str = '('
    if title.include? str
	elements = title.split('(')
	stripped = elements[0].strip
	return stripped
    else
	#puts "does not contain ("
  	return title
    end
end

def parseString2(title)
    if title.include? ':'
	elements = title.split(':')
        return elements[0]
    end
end


def createKeyword(title, id)
    if Keyword.where.not("keyword_phrase = ?", title)
	puts title
        Keyword.create(keyword_phrase:title, movie_id:id, is_hash_tag: false)
    end
end



Movie.select("name, id").each do |movie|
   title = movie.name
   string1 = parseString1(title)
   string1 = string1.squish
   createKeyword(string1, movie.id)
   if string1.include? ':'
	createKeyword(parseString2(string1), movie.id)
   end

end


