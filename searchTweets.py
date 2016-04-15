
from TwitterAPI import TwitterAPI


SEARCH_TERM = 'Zootopia since:2016-04-12 until:2016-04-13'
#SEARCH_TERM = 'Zootopia since:2016-04-01'


CONSUMER_KEY = 'mK9czXCnYHya9ZK4bHrKdM6zu'
CONSUMER_SECRET = 'bE2C2VWxXBwsGdzGaW07lsaOp559BVZKfMe2av5VBXnlLOHNfL'
ACCESS_TOKEN_KEY = '94327203-sEXKa0x6Bg5kgsTeHyJyGd9pfYEsPquhpVpkTyTsv'
ACCESS_TOKEN_SECRET = 'HdUZPQKvAkupRJTPmchkaDtFrnQoaTQum9T4QPuymyaxA'


api = TwitterAPI(CONSUMER_KEY,
                 CONSUMER_SECRET,
                 ACCESS_TOKEN_KEY,
                 ACCESS_TOKEN_SECRET)

r = api.request('search/tweets', {'q': SEARCH_TERM})

for item in r:
    print(item['text'] if 'text' in item else item)

print('\nQUOTA: %s' % r.get_rest_quota())
