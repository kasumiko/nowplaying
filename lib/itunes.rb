module NowPlaying
  class ITunes
    class << self
      def get_track_data
        src = <<~SCRIPT
          tell application "iTunes"
            set trackname to name of current track
            set trackartist to artist of current track
            set albumname to album of current track
            return trackname & "\n" & trackartist & "\n" & albumname
          end tell
        SCRIPT
        track = `osascript <<XXX\n#{src}`.split("\n")
        return {
          name: track[0],
          artist: track[1],
          album: track[2]
        }
      end

      def get_art_work(*)
        src = <<~SCRIPT
          tell application "iTunes"
            tell current track
              if exists artwork 1 then
                try
                  set d to raw data of artwork 1
                on error -1728 then
                  return ""
                end try
                return d
              end if
            end tell
          end tell
        SCRIPT
        art_work = `osascript <<XXX\n#{src}`
        return if art_work == ''
        art_work = art_work.gsub('«data tdta', '').gsub('»', '')
        return [art_work.chomp].pack('H*')
      end
    end
  end
end
