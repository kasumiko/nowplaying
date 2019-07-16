require 'rest-client'
require 'base64'
require 'json'

module NowPlaying
  class Spotify
    SEARCH_URI = 'https://api.spotify.com/v1/search?'
    AUTH_URI = 'https://accounts.spotify.com/api/token'
    class << self
      def get_art_work(name: '', artist: '', album: '')
        return unless ENV['SPOTIFY_SEARCH'] == 'enable'
        return if ENV['SPOTIFY_ID'].empty?||ENV['SPOTIFY_SECRET'].empty?
        search_res = search 'album:' + album + ' artist:' + artist
        return if search_res['albums']['total'].zero?
        pic_url = search_res['albums']['items'][0]['images'][0]['url']
        return RestClient.get pic_url
      end

      def auth
        consumer_key = CGI.escape(ENV['SPOTIFY_ID'])
        consumer_secret = CGI.escape(ENV['SPOTIFY_SECRET'])
        credential = Base64.strict_encode64(consumer_key + ':' + consumer_secret)
        params = { grant_type: 'client_credentials' }
        res = RestClient.post(AUTH_URI, params, Authorization: "Basic #{credential}")
        token = JSON.parse(res.body)['access_token']
        return "Bearer #{token}"
      end

      def search(str)
        params = { q: str, type: 'album' }
        res = RestClient.get(SEARCH_URI, params: params, Authorization: auth)
        return JSON.parse(res.body)
      end
    end
  end
end

