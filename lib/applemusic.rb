require 'oauth'
require 'json'

module NowPlaying
  class AppleMusic
    AM_BASE_URI = 'https://api.music.apple.com/v1/catalog/jp/search?'
    
    def get_art_work(name:'', artist:'', album:'')
      search(name+'+'+artist+'+'+album)
    end

    def search(str)
      param = URI.encode_www_form({term: 'sakanaction', types: 'songs'})
      p param
      uri = URI.parse(AM_BASE_URI+param)
      p uri
      uri = 'https://api.music.apple.com/v1/catalog/us/search?term=james+brown&limit=2&types=artists,albums'

      res = Net::HTTP.get(URI.parse(uri))
      p res
      return JSON.parse(res)
    end
  end
end

p NowPlaying::AppleMusic.new.get_art_work(name: 'ガールズコード',artist: "Poppin'Party",album: "Poppin'on!")
