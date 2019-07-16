require 'open-uri'
require 'rest-client'
require 'json'

module NowPlaying
  class ITunesStore
    SEARCH_URI = 'https://itunes.apple.com/search'
    class << self
      def get_art_work(name: '', artist: '', album: '')
        search_res = search name + '+' + artist + '+' + album
        return get_image search_res
      end

      def get_image(search_res)
        search_res.each { |r|
          pic = RestClient.get(r['artworkUrl100']).body
          return pic unless pic.nil?
        }
        return nil
      end

      def search(str)
        params = { term: str, country: 'jp', media: 'music' }
        res = RestClient.get(SEARCH_URI, params: params)
        return JSON.parse(res.body)['results']
      end
    end
  end
end
