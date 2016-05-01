def createKeyword(title, id)
    unless Keyword.where("keyword_phrase = ? and movie_id = ?", title, id).exists?
	puts title
	puts "where not"
       Keyword.create(keyword_phrase:title, movie_id:id, is_hash_tag: false)
    end
end


File.open('script/keyword.txt').each do |line|
	array = line.split(',')
	puts array[0]
	puts array[1]
	createKeyword(array[1], array[0])
end

