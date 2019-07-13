require 'open-uri'
require 'json'
require 'net/http'

module NowPlaying
  class ITunesStore
    SEARCH_URI = 'https://itunes.apple.com/search?'
    class << self
      def get_art_work(name:'', artist:'', album:'')
        search_res = search name + '+' + artist + '+' + album
        return get_image search_res
      end

      def get_image(search_res)
        search_res.each{|r|
          pic = open(r['artworkUrl100']).read
          return pic if pic != nil
        }
        return nil
      end

      def search(str)
        param = URI.encode_www_form({term: str, country: 'jp',media: 'music'})
        uri = URI.parse SEARCH_URI+param
        res = Net::HTTP.get uri
        return JSON.parse(res)['results']
      end
    end
  end
end

