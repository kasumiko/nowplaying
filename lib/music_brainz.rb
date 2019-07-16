require 'open-uri'
require 'json'
require 'rest-client'

module NowPlaying
  class MusicBrainz
    SEARCH_URI = 'https://musicbrainz.org/ws/2/release-group/'
    class << self
      def get_art_work(name: '', artist: '', album: '')
        return unless ENV['MUSICBRAINZ_SEARCH'] == 'enable'
        search_res = search(artist: artist, album: album)
        return if search_res.nil?
        return get_image search_res, artist
      end

      def get_mbid(search_res, artist)
        search_res['release-groups'].each { |r|
          next unless r['artist-credit'][0]['artist']['name'] == artist
          mbids = []
          mbids << [r['id'], 'release-group']
          r['releases'].each { |r|
            mbids << [r['id'], 'release']
          }
          return mbids
        }
        return []
      end

      def get_image(search_res, artist)
        mbids = get_mbid search_res, artist
        return if mbids.empty?
        mbids.each { |id|
          begin
            res = RestClient.get("https://coverartarchive.org/#{id[1]}/#{id[0]}/front")
            return res.body
          rescue RestClient::NotFound => e
            e.message
            next
          end
        }
      end

      def search(album: '', artist: '')
        params = {
          query: "release-group:#{album} #{artist}",
          fmt: 'json'
        }
        @uri = SEARCH_URI
        res = RestClient.get(@uri, params: params)
        return JSON.parse(res.body)
      end
    end
  end
end
