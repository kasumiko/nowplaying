require 'dotenv'
require_relative './lib/twitter.rb'
require_relative './lib/itunes.rb'
require_relative './lib/itunesstore.rb'
require_relative './lib/music_brainz.rb'
require_relative './lib/spotify.rb'
Dotenv.load File.expand_path(__FILE__).sub(%r{[^\/]+$}, '')
module NowPlaying
  class Main
    def initialize
      @track = ITunes.get_track_data
      @track[:image] = find_artwork
    end

    def tweet
      Twitter.new.tweet @track
    end

    def find_artwork
      srcs = [
        ITunes,
        ITunesStore,
        MusicBrainz,
        Spotify
      ]
      srcs.each { |src|
        art_work = src.get_art_work @track
        return art_work unless art_work.nil?
      }
    end
  end
end

p NowPlaying::Main.new.tweet
