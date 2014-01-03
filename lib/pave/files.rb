module Pave
  class Files
    include Pave::Shell

    def self.clear_cache
      sh "rm -rf ./files/tmp/*; rm -rf ./files/cache/*;"
    end

    def self.clear_remote_cache(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      sh "ssh #{server} 'cd #{directory}/files;
          rm -rf ./tmp/*;
          rm -rf ./cache/*;'"
    end

    def self.push(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      sh "scp -r ./files #{server}:#{directory}/local_files;"
      sh "ssh #{server} 'cd #{directory};
          mv ./files ./old_files;
          mv ./local_files ./files && rm -rf ./old_files;'"
    end

    def self.pull(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      sh "scp -r #{server}:#{directory}/files ./remote_files;
          mv ./files ./old_files;
          mv ./remote_files ./files && rm -rf ./old_files;"
    end
  end
end
