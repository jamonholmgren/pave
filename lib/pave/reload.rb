module Pave
  class Reload
    def self.live_reload
      # docs: http://brettterpstra.com/2011/03/07/watch-for-file-changes-and-refresh-your-browser-automatically/
      trap("SIGINT") { exit }

      puts "Watching #{watch_folder} and subfolders for changes in project files..."

      while true do
        files = []
        filetypes.each {|type|
          files += Dir.glob( File.join( watch_folder, "**", "*.#{type}" ) )
        }
        new_hash = files.collect {|f| [ f, File.stat(f).mtime.to_i ] }
        hash ||= new_hash
        diff_hash = new_hash - hash

        unless diff_hash.empty?
          hash = new_hash

          diff_hash.each do |df|
            puts "Detected change in #{df[0]}, refreshing"
            %x{osascript<<ENDGAME
              tell application "Google Chrome"
                set windowList to every window
                repeat with aWindow in windowList
                  set tabList to every tab of aWindow
                  repeat with atab in tabList
                    if (URL of atab contains "#{keyword}") then
                      tell atab to reload
                    end if
                  end repeat
                end repeat
              end tell
            ENDGAME
            }
          end
        end

        sleep 1
      end

    end

    def self.dev_extension
      "site"
    end

    def self.filetypes
      ['css','html','htm','php','rb','erb','less','js']
    end

    def self.watch_folder
      Dir.pwd
    end

    def self.keyword
      File.basename(Dir.pwd)
    end
  end
end  