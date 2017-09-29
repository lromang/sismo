#! /bin/python2

## libraries
import tweepy
import json
import time
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

## client = MongoClient()
from pymongo import MongoClient
client      = MongoClient()
db          = client.s19_new_tweets_opinion
tweet_posts = db.s19_tweet_posts_opinion

## Read in Tweet
## tweet       = tweet_posts.find_one()
for tweet in tweet_posts.find():
    dateTime = time.strftime('%Y-%m-%d %H:%M:%S', time.strptime(tweet['created_at'],'%a %b %d %H:%M:%S +0000 %Y'))
    print tweet['text'], tweet['timestamp_ms'], dateTime, tweet['favorite_count'], tweet['reply_count']
