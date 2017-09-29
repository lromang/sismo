#! /bin/bash

mongoexport --db s19_new_tweets_opinion --collection s19_tweet_posts_opinion --csv --out /home/luis/Documents/Work/Presidencia/sismo/data/tweet_opinion_matrix.csv --fields id,id_str,text,source,created_at,user.id,user.id_str,user.name,user.screen_name,user.location,user.url,user.description,user.followers_count,user.friends_count,user.created_at,user.time_zone,user.lang,geo.coordinates.0,geo.coordinates.1,coordinates.coordinates.0,coordinates.coordinates.1,place.id,place.url,place.place_type,place.name,place.full_name,place.country,place.bounding_box.coordinates
