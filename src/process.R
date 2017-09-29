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
suppressPackageStartupMessages(library(tau))
suppressPackageStartupMessages(library(qlcMatrix))
suppressPackageStartupMessages(library(text2vec))
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
        str_replace_all('http:[^ ]+')  %>%
        iconv("UTF-8", "ASCII", "")    %>%
        ## short_words(wlength = wlength) %>%
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
if(!file('../outputData/clean_tweets.txt')){
    tweet_text <- tweets$text %>%
        clean_text
    tweet_text <- laply(tweet_text, short_words)
}else{
    tweet_text <- readLines('../outputData/clean_tweets.txt')
}

## ----------------------------------------
## Construct Co-ocurrence matrix
## ----------------------------------------

## First work with sample
set.seed(123454321)
samp       <- sample(length(tweet_text), 100000)
test_tweet <- tweet_text[samp]

## Part whole matrix
pw <- pwMatrix(test_tweet, sep = ' ')

## Type token matrix
tt    <- ttMatrix(pw$rownames)
distr <- (tt$M*1) %*% (pw$M*1)
rownames(distr) <- tt$rownames
colnames(distr) <- test_tweet
distr

## Co-ocurrence counts of adjacent characters
S   <- bandSparse(n = ncol(tt$M), k = 1) * 1
TT  <- tt$M * 1
C   <- TT %*% S %*% t(TT)
##
s      <- summary(C)
first  <- tt$rownames[s[,1]]
second <- tt$rownames[s[,2]]
freq   <- s[,3]
test_m <- data.frame(first, second, freq)
test_m <- test_m[order(test_m$freq, decreasing = TRUE), ]
test_m <- test_m[test_m$freq >= 4, ]

## ----------------------------------------
## Word 2 Vec
## source:
## https://cran.r-project.org/web/packages/text2vec/vignettes/glove.html
## ----------------------------------------
tokens <- space_tokenizer(test_tweet)
it     <- itoken(tokens, progressbar = FALSE)
vocab  <- create_vocabulary(it)
vocab  <- prune_vocabulary(vocab,
                          term_count_min = 5L)

## Filtered vocabulary
vectorizer <- vocab_vectorizer(vocab)

## use window of 5 for context words
tcm        <- create_tcm(it,
                        vectorizer,
                        skip_grams_window = 5)
glove      <- GlobalVectors$new(word_vectors_size = 50,
                               vocabulary        = vocab,
                               x_max             = 10)
glove$fit_transform(tcm, n_iter = 20)

## Word Vectors
word_vectors <- glove$components()

## Gobierno
gobierno <- word_vectors[,"gobierno" , drop = FALSE] +
    word_vectors[,"sismo",  drop = FALSE] +
    word_vectors[,"epn" , drop = FALSE]
cos_sim  <- apply(word_vectors, 2, function(t)t <- t%*%gobierno)

head(sort(cos_sim, decreasing = TRUE), 20)
