require 'oauth'
require 'json'
require 'base64'

module NowPlaying
  class Twitter
    UPLOAD_URI = 'https://upload.twitter.com/1.1/media/upload.json'
    UPDATE_URI = 'https://api.twitter.com/1.1/statuses/update.json?'

    def initialize
      consumer = OAuth::Consumer.new(
        ENV['TWITTER_API_KEY'],
        ENV['TWITTER_API_SECRET'],
        site: 'https://api.twitter.com/'
      )
      @twitter = OAuth::AccessToken.new(
        consumer,
        ENV['TWITTER_ACCESS_TOKEN'],
        ENV['TWITTER_ACCESS_TOKEN_SECRET']
      )
    end
    
    def tweet(name: '', artist: '', album: '', image: '')
      track = format ENV['FORMAT'] ,{
        name: name,
        album: album,
        artist: artist,
        tag: '#' + ENV['TAG']
      }
      text = gets + track
      return with_image image, text unless image.empty?
      params = URI.encode_www_form(
        status: text
      )
      return @twitter.post UPDATE_URI + params 
    end

    def with_image(image,text)
      pic = upload image
      params = URI.encode_www_form(
        status: text,
        media_ids: pic['media_id'].to_s
      )
      return @twitter.post UPDATE_URI + params 
    end

    def upload(image)
      response = post({media_data: Base64.urlsafe_encode64(image)},
                      {'Content-Type' => 'multipart/form-data'})
      return JSON.parse(response.body)
    end

    def post(params, header={})
      @twitter.post UPLOAD_URI, params, header
    end
  end
end


