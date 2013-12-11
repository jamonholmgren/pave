require "pave/shell"

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

    def dump
      if !File.directory?('.db')
        sh "mkdir .db"
        sh "touch .db/index.php"
      end
      say "Creating dump of #{name} at #{Dir.pwd}/.db/#{Time.now.strftime("%Y-%m-%d-%H%M")}-#{name}.sql.gz"
      sh "mysqldump -uroot #{name} | gzip > ./.db/#{Time.now.strftime("%Y-%m-%d-%H%M")}-#{name}.sql.gz"
      say "Dump complete. Running backup dump..."
      
      # backup db
      if !File.directory?('~/DBbackups'+name)
        sh "mkdir -p ~/DBbackups/#{name}"
      end
      sh "mysqldump -uroot #{name} | gzip > ~/DBbackups/#{name}/#{Time.now.strftime("%Y-%m-%d-%H%M")}-#{name}.sql.gz"
      say "Backup dump complete."

    end

    def download(host, user, password)
      # Download the project's live database and replace local database.
      # sh "mysqldump -h#{host} -u#{user} -p#{password} #{name} | mysql -uroot #{name}"
    end

    def upload
      # Upload the project's local database and replace the live database.
    end
  end
end
