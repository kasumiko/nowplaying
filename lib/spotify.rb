require 'net/http'
require 'json'
require 'dotenv/load'

module NowPlaying
  class Spotify
    SEARCH_URI = 'https://api.spotify.com/v1/search?'
    class << self
      def get_art_work(name:'', artist:'', album:'')
        search_res = search name + '+' + artist + '+' + album
      end

      def auth
        request = Net::HTTP::Get.new(@uri.request_uri)
        request["Authorization"] = "Bearer #{ENV['SPOTIFY_TOKEN']}"
        p request["Authorization"]
        return request
      end

      def http_secure
        http = Net::HTTP.new(@uri.host, @uri.port)
        http.use_ssl = true
        return http
      end

      def search(str)
        body = URI.encode_www_form(q: str,type: 'track')
        @uri = URI.parse(SEARCH_URI+body)
        p @uri
        p http_secure.request(auth)
      end
    end
  end
end
