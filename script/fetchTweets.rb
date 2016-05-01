#twitter search
#require 'Twitter'
#require 'json'

$client1 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "mK9czXCnYHya9ZK4bHrKdM6zu"
  config.consumer_secret     = "bE2C2VWxXBwsGdzGaW07lsaOp559BVZKfMe2av5VBXnlLOHNfL"
  config.access_token        = "94327203-sEXKa0x6Bg5kgsTeHyJyGd9pfYEsPquhpVpkTyTsv"
  config.access_token_secret = "HdUZPQKvAkupRJTPmchkaDtFrnQoaTQum9T4QPuymyaxA"
end

$client2 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "VNT2zNsCo0DMAdiE7bSV5D0D2"
  config.consumer_secret     = "USwmXg3bQnQA2HhSiUnFgy5QLwDV8VifyewuOEFfpBfWX6LBqU"
  config.access_token        = "94327203-XIOiJAkHOV6hS46ZhoDWqHWd0ZqfBX68n4IaqO846"
  config.access_token_secret = "L5338QcBW0WzjyZJdTNfXrsNkG3xxWJRPgiEXNEwak0SK"
end

$client3 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "ok2cpc3Qt4zBu9ADBWcdYoBRx"
  config.consumer_secret     = "dRjtLApDWjYR5uLBjYj7ZWKqJhiTofukzYECqvV3O3JRwVzw4p"
  config.access_token        = "94327203-BeZByCBU5PCF6nZtSKuOELd3KhbcOxEi8PBfLGhl7"
  config.access_token_secret = "pwtc2W38nGhpQIx0K2eBGL1WKolNZkMayEZS0IMYXm7wi"
end

$client4 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "zbmdr9C2CfqNRBIaDK5fk41xX"
  config.consumer_secret     = "cSoKNhgjj1J1meEbAfF0goYD0bionbtc6mT6igHHa47JT0vaW5"
  config.access_token        = "94327203-x5EzL7k1Tau4K5NI9ZBDIl1zvkNijufjLLLEgvlUF"
  config.access_token_secret = "DTPR13vNtavI3Mh2FHMrn7A9sHh36SyhU37QqiEygJo83"
end

$client5 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "jQ04HPsp0pGMKL1M1ob7zWyFl"
  config.consumer_secret     = "i4T7ppMoFVedwgkjPp24DyHTmud5DDmGz6a8pxqTVsCql6Edfn"
  config.access_token        = "4915176383-anNnENADdtA5IkiQcZ1ovxv1McBad3tqCJZZFDU"
  config.access_token_secret = "XMvBIsDD2WV4ePPFTqb237wd7NrKwCAlc2IOPVnSVoGpC"
end

$client = $client1

def switchClient 
	puts "switching client"
	if $client == $client1
		$client = $client2
	elsif $client == $client2 
		$client = $client3
	elsif $client == $client3
		$client = $client4
	elsif $client == $client4
		$client = $client5
	else
		$client = $client1
	end
end


def createTweetData(fav, ret, tweets, id, date, pos, neg)
    unless Tweet.where("keyword_id = ? and date = ?", id, date).exists?
       Tweet.create(number_of_favorites: fav, number_of_retweets: ret, number_of_tweets: tweets, keyword_id: id, date: date, positive: pos, negative: neg)
    	puts "created"
    else
    	puts "exist"
    end
end

def getData(result, id, date,  pos, neg)
	puts "get Data"
	fav = 0
	ret = 0

	count = 0

	result.each do |tweet|
		fav += tweet.favorite_count
		ret += tweet.retweet_count
	count = count + 1
	if count == 25000
		break
	end
    if count % 10000 == 0
		puts "sleep"
		i = 0
		sleep(60)
		puts "sleep1"
		sleep(60)
		puts "sleep2"
		sleep(60)
		puts "sleep3"
		sleep(60)
		puts "sleep4"
		sleep(60)
		puts "sleep5"
		sleep(60)
		puts "sleep6"
		sleep(60)
		puts "sleep7"
		sleep(60)
		puts "sleep8"
		sleep(60)
		puts "sleep9"
		sleep(60)
		puts "sleep10"
		sleep(60)
		puts "sleep11"
		sleep(60)
		puts "sleep12"
		sleep(60)
		puts "sleep13"
		sleep(60)
		puts "sleep14"
		sleep(60)
		puts "sleep15"
		puts "sleep end"
	end
	puts count
	puts fav
	puts ret

	end
	puts count
	puts fav
	puts ret
	createTweetData(fav, ret, count, id, date, pos, neg)
end

$current = Time.new
#puts $current.strftime "%Y-%m-%d"

def getQueryDaysAgo(daysago, keyword)
	t1 = $current - (60*60*24)*daysago
	t2 = t1 + (60*60*24)
	#puts t1.strftime "%Y-%m-%d"

	phrase = keyword+" since:"+(t1.strftime "%Y-%m-%d") + " until:" +(t2.strftime "%Y-%m-%d")
#	puts phrase
end

def getPositiveQueryDaysAgo(daysago, keyword)
	t1 = $current - (60*60*24)*daysago
	t2 = t1 + (60*60*24)
	#puts t1.strftime "%Y-%m-%d"

	phrase = keyword+" :) since:"+(t1.strftime "%Y-%m-%d") + " until:" +(t2.strftime "%Y-%m-%d")
#	puts phrase
end

def getNegativeQueryDaysAgo(daysago, keyword)
	t1 = $current - (60*60*24)*daysago
	t2 = t1 + (60*60*24)
	#puts t1.strftime "%Y-%m-%d"

	phrase = keyword+" :() since:"+(t1.strftime "%Y-%m-%d") + " until:" +(t2.strftime "%Y-%m-%d")
#	puts phrase
end


getQueryDaysAgo(2, "abc")


$success = true 

def iterateKeywords(daysago) 
	puts "iterate keywords"
	if daysago > 7
		return
	end
	Keyword.select("keyword_phrase, id").reverse.each do |keyword|
	  keyword_id = keyword.id
	  phrase = keyword.keyword_phrase
	  q1 = getQueryDaysAgo(daysago, phrase)
	  q2 = getNegativeQueryDaysAgo(daysago, phrase)
	  q3 = getPositiveQueryDaysAgo(daysago, phrase)
	   t1 = $current - (60*60*24)*daysago
	  date = (t1.strftime "%Y-%m-%d")
	  unless Tweet.where("keyword_id = ? and date = ?", keyword_id, date).exists?
	$success = true
	i = 0
    while $success
    	i = i + 1
    	if i%10 == 0
    		sleep(60*3)
    	end

	begin
	  puts "begin"
	  result1 = $client.search(q1, lang:"en", count:100)
	puts "result1"
	  result2 = $client.search(q3, lang:"en", count:100).count
	puts "result2"
	  result3 = $client.search(q2, lang:"en", count:100).count
	puts "result3"
	  getData(result1, keyword_id, date, result2, result3)
	  $success = false
	rescue

	switchClient
	
	end
	end
else
	puts "tweet data exist"
	end
   #  result1.each do |tweet|

   #    	puts tweet.text
  	# end
  	# result2.each do |tweet|
   #    	puts tweet.text
  	# end
  	# result3.each do |tweet|
   #    	puts tweet.text
  	# end
   end
end

ARGV.each do|a|
	iterateKeywords(a.to_i)
	puts a
 # puts "Argument: #{a}"
end
#iterateKeywords(2)

#Keyword.select("keyword_phrase, id").each do |keyword|
#   keyword_id = keyword.id
#   phrase = keyword.keyword_phrase
#   client.search(phrase, lang: "en", count: 100).take(3).each do |tweet|
#      puts tweet.text
#   end
#end
