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

    def dump_file
      "#{Time.now.strftime("%Y-%m-%d")}-#{name}.sql.gz"
    end

    def dump
      if !File.directory?('db')
        sh "mkdir ./db"
        sh "echo '<?= die(); ?>' > ./db/index.php"
        sh "echo 'deny from all' > ./db/.htaccess"
        sh "sudo chmod -R 700 ./db/"
      end
      say "Creating dump of #{name} at #{Dir.pwd}/db/#{dump_file}"
      sh "mysqldump -uroot #{name} | gzip > ./db/#{dump_file}"
    end

    def dump_remote(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      db = remote_db
      say "Remotely creating dump of #{db['name']} at #{server}:#{directory}/db/#{dump_file}"
      sh "ssh #{server} \"cd #{directory}/db; mysqldump -u#{db['user']} -p#{db['pass']} #{db['name']} | gzip > #{dump_file}\""
    end

    def execute
      say "Executing #{dump_file} on #{name}"
      sh "gzip -dc ./db/#{dump_file} | mysql -uroot #{name}"
    end

    def execute_remote(remote="live")
      server = Pave::Remote.server(remote)
      directory = Pave::Remote.directory(remote)
      say "Remotely executing #{dump_file} on live #{db['name']}"
      sh "ssh #{server} \"cd #{directory}/db; gzip -dc #{dump_file} | mysql -u#{db['user']} -p#{db['pass']} #{db['name']}\""
    end

    def upload(remote="live")
      # Upload the project's local database dump to remotes db directory.
      say "Uploading SQL dump to #{remote_url}/db/#{dump_file}"
      sh "scp ./db/#{dump_file} #{remote_url}/db"
    end

    def download(remote="live")
      # Download the project's live database dump to local db directory.
      say "Downloading SQL dump from #{remote_url}/db/#{dump_file}"
      sh "scp #{remote_url}/db/#{dump_file} ./db"
    end

    def push(remote="live")
      # Upload the project's local database and replace the live database.
      dump
      upload(remote)
      execute_remote(remote)
    end

    def pull(remote="live")
      # Download the project's live database and replace local database.
      dump_remote(remote)
      download(remote)
      execute
    end
  end
end
