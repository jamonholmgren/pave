module Pave
  class Deploy
    include Pave::Shell

    def setup
      copy_git_folder
      add_git_remote
      make_executable
    end

    def deploy(remote="production", branch="master")
      sh "git push #{remote} #{branch}"
    end

    def copy_git_folder
      # sh "scp -r ./.git your_username@remotehost.edu:/some/remote/directory"
    end

    def add_git_remote
    end

    def make_executable
    end
  end
end
