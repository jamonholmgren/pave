module Pave
  class Deploy
    include Pave::Shell

    def setup
      # Get server, folder, and desired git remote name
      server = ask "Enter the username and hostname of the remote server (e.g. user@server.com): "
      folder = ask "Enter the name of the remote directory (e.g. ~/webapps/appname/): "
      remote = ask "Enter the desired git remote name (e.g. production): "

      # Create a temporary shell script to send to the remote server
      sh "echo \"#!bin/bash\" > tempgitdeploysetup.sh"
      sh "echo \"cd #{folder}\" >> tempgitdeploysetup.sh"
      sh "echo \"if [ ! -d 'deploy.git' ]; then\" >> tempgitdeploysetup.sh"
      sh "echo \"mkdir deploy.git && cd deploy.git\" >> tempgitdeploysetup.sh"
      sh "echo \"git init --bare\" >> tempgitdeploysetup.sh"
      sh "echo \"unlink hooks/post-receive\" >> tempgitdeploysetup.sh"
      sh "echo \"echo '#!/bin/sh' > hooks/post-receive\" >> tempgitdeploysetup.sh"
      sh "echo \"echo 'GIT_WORK_TREE=.. git checkout -f' >> hooks/post-receive\" >> tempgitdeploysetup.sh"
      sh "echo \"chmod +x hooks/post-receive\" >> tempgitdeploysetup.sh"
      sh "echo \"fi\" >> tempgitdeploysetup.sh"
      sh "echo \"if [ ! -d '~/.ssh' ]; then\" >> tempgitdeploysetup.sh"
      sh "echo \"mkdir ~/.ssh\" >> tempgitdeploysetup.sh"
      sh "echo \"fi\" >> tempgitdeploysetup.sh"
      sh "echo \"chmod 700 ~/.ssh\" >> tempgitdeploysetup.sh"
      sh "echo \"touch ~/.ssh/authorized_keys\" >> tempgitdeploysetup.sh"
      sh "echo \"chmod 644 ~/.ssh/authorized_keys\" >> tempgitdeploysetup.sh"

      puts "Piping shell script to #{server} for setup."
      sh "ssh #{server} 'bash -s' < tempgitdeploysetup.sh"

      # Remove the temp file
      sh "rm tempgitdeploysetup.sh"

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

