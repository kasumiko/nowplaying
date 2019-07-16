# NowPlaying on OSX
## What

The CLI App which tweet the music what you are listening on iTunes.

This App uses osascript, thus it can be used on OSX. 

## Set Up
Rename a `example_config` file to `config` and fill out your twitter authentication parameters.

```
#--------Your Twitter OAuth keys--------
# Required!
TWITTER_API_KEY = 
TWITTER_API_SECRET = 
TWITTER_ACCESS_TOKEN = 
TWITTER_ACCESS_TOKEN_SECRET = 
# Required!
```
Execute `bundle install`. 
If it fail, execute `rm Gemfile.lock` and retry.

## Usage
Execute `bundle exec ruby nowplaying.rb`.

And input text what you want to tweet with track infomations.
