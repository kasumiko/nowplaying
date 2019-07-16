require 'json'
require 'rest-client'
require 'dotenv/load'
require 'base64'

SPOTURL = 'https://accounts.spotify.com/api/token'
consumer_key = URI.encode(ENV['SPOTIFY_ID'])
consumer_secret = URI.encode(ENV['SPOTIFY_SECRET'])
credential = Base64.strict_encode64(consumer_key+':'+consumer_secret)
params = {grant_type: 'client_credentials'}
res = RestClient.post(SPOTURL, params, {Authorization: "Basic #{credential}"})
token = JSON.parse(res.body)['access_token']
