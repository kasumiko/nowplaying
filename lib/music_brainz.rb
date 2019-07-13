require 'open-uri'
require 'json'
require 'net/http'

module NowPlaying
  class MusicBrainz
    SEARCH_URI = 'https://musicbrainz.org/ws/2/release/?'
    class << self
      def get_art_work(name:'', artist:'', album:'')
        search_res = search(artist: artist,album: album)
        return if search_res.nil?
        return get_image search_res, artist
      end

      def get_mbid(search_res,artist)
        search_res['releases'].each{|r|
          return r['id'] if r['artist-credit'][0]['artist']['name'] == artist
        }
      end

      def get_image(search_res, artist)
        mbid = get_mbid search_res, artist
        res = Net::HTTP.get URI.parse "https://coverartarchive.org/release/#{mbid}/front"
        image = res.gsub('See: ','').chomp
        return open(image).read
      end

      def user_agent
        request = Net::HTTP::Get.new(@uri.request_uri)
        request["User-Agent"] = "kasuplaying"
        return request
      end

      def http_secure
        http = Net::HTTP.new(@uri.host, @uri.port)
        http.use_ssl = true
        return http
      end

      def search(album:'',artist:'')
        param = URI.encode_www_form({
          query: "release:#{album}",
          fmt: 'json'
        })
        @uri = URI.parse SEARCH_URI+param
        res = http_secure.request(user_agent)
        return JSON.parse(res.body)
      end
    end
  end
end

