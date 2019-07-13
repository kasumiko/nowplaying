require 'json'
require 'net/http'
require 'dotenv/load'
require 'base64'

SPOTURL = 'https://accounts.spotify.com/api/token'
uri = URI.parse(SPOTURL)
request = Net::HTTP::Post.new(uri)
consumer_key = URI.encode(ENV['SPOTIFY_ID'])
consumer_secret = URI.encode(ENV['SPOTIFY_SECRET'])
req_options = {use_ssl: uri.scheme == "https"} 
request.set_form_data('grant_type' =>'client_credentials')
req = Net::HTTP::Post.new(uri.request_uri)
credential = Base64.strict_encode64(consumer_key+':'+consumer_secret)
p credential
request['Authorization'] = "Basic #{credential}"
res = Net::HTTP.start(uri.hostname,uri.port,req_options) do |http|
  http.request(request)
end
p res
p JSON.parse(res.body)
