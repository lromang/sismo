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
db          = client.s19_new_tweets_opinion
tweet_posts = db.s19_tweet_posts_opinion

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
    auth.set_access_token(access_token, access_token_secret)
    ## API
    ## api = tweepy.API(auth)
    ## Creating stream listener
    myStream  = Stream(auth     = auth,
                       listener = StdOutListener())
    ## Track Tweets
    myStream.filter(locations = [ -116.227835, 13.488936, -93.847343, 25.803026],
                    track     = ['19S', 'FuerzaMexico', 'gobierno', 'sismo', 'temblor', '@epn', '@gobmx'])
