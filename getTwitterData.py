from TwitterSearch import *
from datetime import datetime
import time

from datetime import timedelta, date

def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days)):
        yield start_date + timedelta(n)

#start_date = date(2016, 3, 1)
#end_date = date(2016, 4, 2)
#for single_date in daterange(start_date, end_date):
#    print single_date.strftime("%Y-%m-%d")

#today = datetime.datetime.today()
#print today
#print today.strftime("%Y-%m-%d")
#print today
def stringDate(date):
    return date.strftime("%Y-%m-%d")



def search(movie, sinceDate, untilDate, keyword_id):
    print untilDate
    tso = TwitterSearchOrder()
    since = 'since:'+sinceDate
    until = 'until:'+untilDate
    keywords = [movie, since, until]
    print keywords
    keywords = ['Zootopia','since:2016-02-06','until:2016-02-07']
   # print keywords
   # tso.set_keywords(keywords) # let's define all words we would like to have a look for
  #  tso.set_keywords(['Zootopia','since:2016-03-10','until:2016-03-11'])
    tso.set_keywords(['Zootopia','since:'+sinceDate,'until:'+untilDate])
    tso.set_language('en') # we want to see German tweets only
    tso.set_include_entities(False) # and don't give us all those entity information
    tso.arguments = {'count': '100'}
    total_num_tweet = 0
    total_retweet = 0
    total_favorite = 0
    a = []
    for tweet in ts.search_tweets_iterable(tso):
   #     print('%s %s' % (tweet['retweet_count'], tweet['favorite_count']))
        total_num_tweet = total_num_tweet+1
        total_retweet += tweet['retweet_count']
        total_favorite += tweet['favorite_count']
    a.append(total_favorite)
    a.append(total_retweet)
    a.append(total_num_tweet)
    a.append(keyword_id)
    a.append(sinceDate)
   # print a
    return a

def searchAll(movie, start, end, keyword_id):
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
    file.close()

try:
   
    # it's about time to create a TwitterSearch object with our secret tokens
    ts = TwitterSearch(
        consumer_key = 'mK9czXCnYHya9ZK4bHrKdM6zu',
        consumer_secret = 'bE2C2VWxXBwsGdzGaW07lsaOp559BVZKfMe2av5VBXnlLOHNfL',
        access_token = '94327203-sEXKa0x6Bg5kgsTeHyJyGd9pfYEsPquhpVpkTyTsv',
        access_token_secret = 'HdUZPQKvAkupRJTPmchkaDtFrnQoaTQum9T4QPuymyaxA'
     )
    searchAll('Zootopia', '2016-04-08', '2016-04-13',1)
  #  searchAll('Zootopia', date(2016,4,1), date(2016,4,10), 1)

except TwitterSearchException as e: # take care of all those ugly errors if there are some
    print(e)



