##########################################
##
## Luis Manuel Román García
## luis.roangarci@gmail.com
##
## ----------------------------------------
###########################################

## ----------------------------------------
## Libraries
## ----------------------------------------
## JSON manipulatino
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(rjson))
suppressPackageStartupMessages(library(RJSONIO))
## XML
suppressPackageStartupMessages(library(XML))
## Urls manipulation
suppressPackageStartupMessages(library(RCurl))
## Manejo de arreglos
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))
## Manejo de cadenas de caracteres
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(tm))
## Manejo de data frames
suppressPackageStartupMessages(library(data.table))
## Predicción
suppressPackageStartupMessages(library(caret))
## Geoespacial
suppressPackageStartupMessages(library(geosphere))
suppressPackageStartupMessages(library(maps))
suppressPackageStartupMessages(library(maptools))
suppressPackageStartupMessages(library(spatstat))
suppressPackageStartupMessages(library(rgeos))
suppressPackageStartupMessages(library(rgdal))
suppressPackageStartupMessages(library(geojsonio))
suppressPackageStartupMessages(library(raster))
## Gráficas
suppressPackageStartupMessages(library(ggplot2))
## Otros
suppressPackageStartupMessages(library(ggmap))
suppressPackageStartupMessages(library(deldir))
suppressPackageStartupMessages(library(rje))
suppressPackageStartupMessages(library(sp))
suppressPackageStartupMessages(library(SDMTools))
suppressPackageStartupMessages(library(PBSmapping))
suppressPackageStartupMessages(library(prevR))
suppressPackageStartupMessages(library(foreign))

###########################################
## Functions
###########################################

## ----------------------------------------
## Text Processing
## ----------------------------------------

## Clean text
clean_text <- function(text, wlength = 2){
    ## Stop Words
    stopwords_regex <- paste(stopwords('es'), collapse = '\\b|\\b')
    stopwords_regex <- paste0('\\b', stopwords_regex, '\\b')
    ## Text processing
    text <- text                        %>%
        removeNumbers()                %>%
        tolower()                      %>%
        removePunctuation()            %>%
        str_replace_all('\\n', "")     %>%
        str_replace_all("\t", "")      %>%
        iconv("UTF-8", "ASCII", "")    %>%
        short_words(wlength = wlength) %>%
        stringr::str_replace_all(stopwords_regex, '')
    text
}

## Short Words
short_words <- function(text, wlength = 2){
    words <- tokenize(text)
    paste(words[str_length(words) > wlength], collapse = ' ')
}

###########################################
###########################################
############### EXECUTE ###################
###########################################
###########################################

## ----------------------------------------
## Read in data
## ----------------------------------------
tweets     <- fread('../data/tweet_opinion_matrix.csv')

## ----------------------------------------
## Clean Text
## ----------------------------------------
tweet_text <- tweets$text %>%
    clean_text
writeLines(tweet_text, '../outputData/clean_tweets.txt')
