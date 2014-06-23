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
      sh "rm -rf ./files/tmp/*; rm -rf ./files/cache/*;"
    end

    def self.push(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      sh "rsync #{flags} #{exclusions} ./files/* #{server}:#{directory}/files/*"
    end

    def self.pull(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      sh "rsync #{flags} #{exclusions} #{server}:#{directory}/files/* ./files/*"
      clear_cache
    end

    def self.sync(remote="live")
      pull(remote)
      push(remote)
    end
  end
end
