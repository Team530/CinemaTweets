#!/usr/bin/python
import tweepy
import csv #Import csv
from datetime import datetime
import time

from datetime import timedelta, date
auth = tweepy.auth.OAuthHandler('mK9czXCnYHya9ZK4bHrKdM6zu', 'bE2C2VWxXBwsGdzGaW07lsaOp559BVZKfMe2av5VBXnlLOHNfL')
auth.set_access_token('94327203-sEXKa0x6Bg5kgsTeHyJyGd9pfYEsPquhpVpkTyTsv', 'HdUZPQKvAkupRJTPmchkaDtFrnQoaTQum9T4QPuymyaxA')

api = tweepy.API(auth)


def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days)):
        yield start_date + timedelta(n)

def stringDate(date):
    return date.strftime("%Y-%m-%d")



def search(movie, sinceDate, untilDate, keyword_id):
    print untilDate
  #  tso = TwitterSearchOrder()
    since = 'since:'+sinceDate
    until = 'until:'+untilDate
    keywords = [movie, since, until]
    print keywords
    keywords = ['Zootopia','since:2016-02-06','until:2016-02-07']


   # print keywords
   # tso.set_keywords(keywords) # let's define all words we would like to have a look for
  #  tso.set_keywords(['Zootopia','since:2016-03-10','until:2016-03-11'])
  #  tso.set_keywords(['Zootopia','since:'+sinceDate,'until:'+untilDate])
  #  tso.set_language('en') # we want to see German tweets only
  #  tso.set_include_entities(False) # and don't give us all those entity information
  #  tso.arguments = {'count': '100'}
    total_num_tweet = 0
    total_retweet = 0
    total_favorite = 0
    a = []
    #search_tweets = api.search(q="Zootopia",since=sinceDate,until=untilDate,lang="en", count=100)

    search_tweets = api.search(q="hello", count=100)
    searched_tweets = [status for status in search_tweets]
    for tweet in searched_tweets:
    #tweepy.Cursor(api.search,q="Zootopia",since=sinceDate,until=untilDate,lang="en").items():
        print(tweet)

        total_num_tweet = total_num_tweet+1
        total_retweet += tweet.retweet_count
      #  total_retweet += tweet['retweet_count']
        total_favorite += tweet['favorite_count']
    #Write a row to the csv file/ I use encode utf-8
    a.append(total_favorite)
    a.append(total_retweet)
    a.append(total_num_tweet)
    a.append(keyword_id)
    a.append(sinceDate)
    #csvWriter.writerow([tweet.created_at, tweet.text.encode('utf-8')])
   # print tweet.created_at, tweet.text
	#csvFile.close()




   # print a
    return a

def searchAll(movie, start, end, keyword_id):
	#csvFile = open('result.csv', 'a')
	#Use csv Writer
	#csvWriter = csv.writer(csvFile)
    file = open('input', 'w')
    start_date = datetime.strptime(start, '%Y-%m-%d')
    print(start_date)
   # start_date = date(2016, 4, 5)
   # end_date = date(2016, 4, 10)
    end_date = datetime.strptime(end, '%Y-%m-%d')

    for single_date in daterange(start_date, end_date):
       # print single_date
        arr = search(movie, stringDate(single_date), stringDate(single_date+timedelta(days=1)), keyword_id)
        print arr
        s = ",".join(str(x) for x in arr)
        file.write("%s\n"%s)
    	#csvWriter.writerow([tweet.created_at, tweet.text.encode('utf-8')])
	#file.close()# Open/Create a file to append data

searchAll('Zootopia', '2016-04-10', '2016-04-11',1)


#start_date = date(2016, 3, 1)
#end_date = date(2016, 4, 2)
#for single_date in daterange(start_date, end_date):
#    print single_date.strftime("%Y-%m-%d")

#today = datetime.datetime.today()
#print today
#print today.strftime("%Y-%m-%d")
#print today



