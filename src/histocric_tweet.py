#! /bin/python2

## libraries
import tweepy
import json
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
## client = MongoClient()
from pymongo import MongoClient
client      = MongoClient()
db          = client.s19_new_tweets_opinion_historic
tweet_posts = db.s19_tweet_posts_opinion_historic

## db = client.tweets

class StdOutListener(StreamListener):
    def on_data(self, data):
        print(data)
        jtweet = json.loads(data, parse_int = str)
        tweet_posts.insert_one(jtweet)
        return True

    def on_error(self, status):
        print(status)

## --------------------------------------------------
## --------------------------------------------------

## main
if __name__ == '__main__':
    consumer_key        = 'r8FHKdxwQsVQfgBZXHoitfPen'
    consumer_secret     = 'rQgXMqaEJ0xoZ9780nYopuQmD9HusRaZKrDVdhdpOYO89MaTWR'
    access_token        = '235347211-tfa1HXLLL9PE4AlphA0z01dnOEOBPkIfk972vu2w'
    access_token_secret = 'xMwO8RdwrIokY0eLHiHCXFUZoGrAFvpkIJCDQGMy1qECz'
    auth                = tweepy.OAuthHandler(consumer_key, consumer_secret)
    ## Set Access
    OAUTH_KEYS = {'consumer_key'        : consumer_key,
                  'consumer_secret'     : consumer_secret,
                  'access_token'        : access_token,
                  'access_token_secret' : access_token_secret}
    auth       = tweepy.OAuthHandler(OAUTH_KEYS['consumer_key'], OAUTH_KEYS['consumer_secret'])
    api        = tweepy.API(auth)
    ## Creating listener
    sisTweet = tweepy.Cursor(api.search,
                             q = ('gobierno' or 'sismo' or 'temblor' or '@epn' or '@gobmx'),
                             geocode = "19.418285,-99.182006,10km",
                             count   = 1000000)

    for tweet in sisTweet.items(limit = 1000000):
        j_tweet = json.dumps(tweet._json)
        jtweet  = json.loads(j_tweet, parse_int = str)
        tweet_posts.insert_one(jtweet)
