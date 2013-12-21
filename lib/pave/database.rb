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

    def drop
      destroy = agree("Are you sure you want to drop #{name}? All data will be lost.")
      sh "mysql -uroot -e 'DROP DATABASE #{name}'" if destroy
    end

    def remote_db
      require 'json'
      live_domain = shell("php -r \"error_reporting(0);require('./config/site.php');echo LIVE_DOMAIN;\"").output
      db_json = shell("php -r \"error_reporting(0);"\
                      "\\$_SERVER = array('HTTP_HOST' => '#{live_domain}');"\
                      "require('./config/site.php');"\
                      "echo json_encode("\
                        "array('host' => DB_SERVER,"\
                              "'user' => DB_USERNAME,"\
                              "'pass' => DB_PASSWORD,"\
                              "'name' => DB_DATABASE));\"").output
      JSON.parse(db_json)
    end

    def remote_url(remote="live")
      "#{Pave::Remote.server(remote)}:#{Pave::Remote.directory(remote)}"
    end

    def dump_file(which_db)
      @dump_file_name ||= {}
      @dump_file_name[which_db] ||= "#{Time.now.strftime("%Y-%m-%d_%H-%M-%S")}-#{name}-#{which_db}.sql.gz"
    end

    def dump
      if !File.directory?('db')
        sh "mkdir ./db"
        sh "echo '<?= die(); ?>' > ./db/index.php"
        sh "echo 'deny from all' > ./db/.htaccess"
        sh "sudo chmod -R 700 ./db/"
      end
      say "Creating dump of #{name} at #{Dir.pwd}/db/#{dump_file(:local)}"
      sh "mysqldump -uroot #{name} | gzip > ./db/#{dump_file(:local)}"
    end

    def dump_remote(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      db = remote_db
      say "Remotely creating dump of #{db['name']} at #{server}:#{directory}/db/#{dump_file(:remote)}"
      sh "ssh #{server} \"cd #{directory}/db; mysqldump -u#{db['user']} -p#{db['pass']} #{db['name']} | gzip > #{dump_file(:remote)}\""
    end

    def execute
      say "Executing #{dump_file(:local)} on #{name}"
      sh "gzip -dc ./db/#{dump_file(:local)} | mysql -uroot #{name}"
    end

    def execute_remote(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      db = remote_db
      say "Remotely executing #{dump_file(:local)} on live #{db['name']}"
      sh "ssh #{server} \"cd #{directory}/db; gzip -dc #{dump_file(:local)} | mysql -u#{db['user']} -p#{db['pass']} #{db['name']}\""
    end

    def upload(remote="live")
      # Upload the project's local database dump to remotes db directory.
      say "Uploading ./db/#{dump_file(:local)} SQL dump to #{remote_url}/db/#{dump_file(:local)}"
      sh "scp ./db/#{dump_file(:local)} #{remote_url}/db/#{dump_file(:local)}"
    end

    def download(remote="live")
      # Download the project's live database dump to local db directory.
      say "Downloading SQL dump from #{remote_url}/db/#{dump_file(:remote)} to ./db/#{dump_file(:remote)}"
      sh "scp #{remote_url}/db/#{dump_file(:remote)} ./db/#{dump_file(:remote)}"
    end

    def push(remote="live")
      # Upload the project's local database and replace the live database.
      dump_remote(remote) # for backup purposes
      download(remote)
      dump
      upload(remote)
      execute_remote(remote)
    end

    def pull(remote="live")
      # Download the project's live database and replace local database.
      dump # for backup purposes
      dump_remote(remote)
      download(remote)
      execute
    end
  end
end
