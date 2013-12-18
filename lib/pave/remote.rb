module Pave
  class Remote
    include Pave::Shell

    def self.setup
      server = ask "Username and hostname of the remote server (e.g. user@server.com): "
      folder = ask "Name of the remote directory (e.g. ~/webapps/appname/): "
      remote = ask "Desired git remote name (e.g. live): "
      script = File.join(File.expand_path("../..", File.dirname(__FILE__)), "resources/deploy.sh")

      puts "Piping shell script to #{server} for setup."
      sh "ssh #{server} 'cd #{folder}; bash -s' < #{script}"

      sh "git remote remove #{remote}"
      sh "git remote add #{remote} #{server}:#{folder}/deploy.git"

      puts "Finished! You may now run `pave deploy` to deploy your application."
    end

    def self.deploy(remote="live", branch="master")
      sh "git push #{remote} #{branch}"
    end

    def self.url(remote="live")
      remotes = shell("git remote -v").output
      remotes.match(/#{remote}\s+(.*)\s+\(push\)/)[1]
    end

    def self.server(remote="live")
      self.url(remote).split(":").first
    end

    def self.directory(remote="live")
      self.url(remote).split(":").last.gsub("/deploy.git", "")
    end
  end
end

