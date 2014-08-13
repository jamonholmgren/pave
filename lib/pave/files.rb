module Pave
  class Files
    include Pave::Shell

    def self.exclusions
      " --exclude 'files/tmp' --exclude 'files/cache' "
    end

    def self.flags
      " -uazh -e ssh --progress "
    end

    def self.clear_cache
      say "Clearing Cache"
      sh "sudo rm -rf ./files/tmp; sudo rm -rf ./files/cache;"
    end

    def self.push(remote="live", method="zip")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      clear_cache
      if method == "rsync"
        sh "rsync #{flags} #{exclusions} ./files/* #{server}:#{directory}/files/*"
      else
        zip_files('local')
        say "Pushing zip to remote server"
        sh "scp ./tmp_files_zip_local.zip #{remote_url}"
        if backup_files('remote', remote)
          if unzip_files('remote', remote)
            remove_zipped_files
          end
        end
        say "Done"
      end
    end

    def self.pull(remote="live", method="zip")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      clear_cache
      if method == "rsync"
        sh "rsync #{flags} #{exclusions} #{server}:#{directory}/files/* ./files/*"
      else
        if backup_files('local')
          if backup_files('remote', remote)
            say "Downloading zip from remote server"
            sh "scp #{remote_url}/tmp_files_zip_remote.zip ./"
            if unzip_files('local')
              remove_zipped_files
            end
          end
        end
      end
    end

    def self.sync(remote="live")
      pull(remote)
      push(remote)
    end

    def self.zip_files(location="local")
      say "Zipping local files"
      sh "zip -9 -r tmp_files_zip_#{location}.zip ./files"
    end

    def self.backup_files(location="local", remote)
      if location == "local"
        zip_files('local')
      else
        server = Pave::Remote.server(remote)
        directory = Pave::Remote.directory(remote)
        sh "ssh #{server} \"cd #{directory}; zip -9 -r tmp_files_zip_remote.zip ./files\""
      end
    end

    def self.unzip_files(location="local", remote)
      if location == "local"
        sh "rm -rf ./files; unzip tmp_files_zip_remote.zip"
      else
        server = Pave::Remote.server(remote)
        directory = Pave::Remote.directory(remote)
        sh "ssh #{server} \"cd #{directory}; rm -rf files/; unzip tmp_files_zip_local.zip\""
      end
    end

    def self.remove_zipped_files
      say "Cleaning up"
      sh "rm -rf tmp_files_zip_local.zip; rm -rf tmp_files_zip_remote.zip"
    end

    def self.remote_url(remote="live")
      "#{Pave::Remote.server(remote)}:#{Pave::Remote.directory(remote)}"
    end
  end
end
