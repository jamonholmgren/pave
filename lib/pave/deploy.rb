module Pave
  class Deploy
    include Pave::Shell

    def setup
      # Get server, folder, and desired git remote name
      server = ask "Enter the username and hostname of the remote server (e.g. user@server.com): "
      folder = ask "Enter the name of the remote directory (e.g. ~/webapps/appname/): "
      remote = ask "Enter the desired git remote name (e.g. production): "

      puts "Piping shell script to #{server} for setup."
      script_path = File.join(File.expand_path("../..", File.dirname(__FILE__)), "resources/deploy.sh")

      sh "ssh #{server}:#{folder} 'bash -s' < #{script_path}"

      # Add git remote
      sh "git remote remove #{remote}"
      sh "git remote add #{remote} #{server}:#{folder}/deploy.git"

      puts "Finished!"
      puts "You may now run `pave deploy` to deploy your application."
    end

    def deploy(remote="production", branch="master")
      sh "git push #{remote} #{branch}"
    end
  end
end

