module Pave
  class Database
    include Pave::Shell

    attr_accessor :name

    def self.create(name)
      say ""
      return say "Options should be given after the database name. For details run: `pave help`" unless name && name.size > 0
      say "Creating mysql database: #{name}."
      new(name).setup
    end

    def initialize(name)
      @name = name
    end

    def setup
      sh "mysql -uroot -e 'CREATE DATABASE #{name}'"
    end

    # We should think about moving these three into deploy.rb and renaming it remote.rb

    def remote_url
      # Get remote url from .git/config
      #
      # [remote "live"]
      #   url = clearsight@cloud.joescan.com:/var/www/html/deploy.git
    end

    def remote_server
      # Split remote_url on ':' return first
      # remote_url.split(":").first
    end

    def remote_dir
      # Split remote_url on ':' return last
      # remote_url.split(":").last.gsub("/deploy.git", "")
    end

    ###########################################################################

    def remote_db_credentials
      # Read config/site.php and get remote db host, user, pass, and name
    end

    def dump_file
      "#{Time.now.strftime("%Y-%m-%d")}-#{name}.sql.gz"
    end

    def dump
      say "Creating dump of #{name} at #{Dir.pwd}/#{dump_file}"
      sh "mysqldump -uroot #{name} | gzip > #{dump_file}"
    end

    def dump_remote
      # sh "ssh #{remote_server} 'cd #{remote_dir}/db; mysqldump -u#{user} -p#{password} #{name} | gzip > #{dump_file}'"
    end

    def execute
      # Execute SQL file.
      # sh "gzip -dc #{file} | mysql -u#{user} -p#{pass} #{name}"
    end

    def execute_remote
      # Execute SQL file on remote db.
      # sh "ssh #{remote_server} 'cd #{remote_dir}/db; gzip -dc #{file} | mysql -u#{user} -p#{pass} #{name}'"
    end

    def upload
      # Upload the project's local database dump to remotes db directory.
      # sh "scp ./db/#{dump_file} #{remote_url}/db"
    end

    def download
      # Download the project's live database dump to local db directory.
      # sh "scp #{remote_url}/db/#{dump_file} ./db"
    end

    def push
      # Upload the project's local database and replace the live database.
      # upload
      # execute_remote
    end

    def pull
      # Download the project's live database and replace local database.
      # download
      # execute
    end
  end
end
