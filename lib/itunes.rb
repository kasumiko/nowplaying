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

      def get_art_work(*arg)
        src = <<~SCRIPT
          tell application "iTunes"
            tell current track
              if exists artwork 1 then
                set d to raw data of artwork 1
                set filepath to ((path to desktop) as text) & ".hoge.png"
                set b to open for access file filepath with write permission
                set eof b to 0
                write d to b starting at 0
                close access b
                return d
              end if
            end tell
          end tell
        SCRIPT
        art_work = `osascript <<XXX\n#{src}`
        return if art_work == ''
        art_work = art_work.gsub("«data tdta","").gsub("»","")
        return [art_work.chomp].pack("H*")
      end
    end
  end
end

