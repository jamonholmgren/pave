require "fileutils"

module Pave
  class VirtualHost
    include Pave::Shell

    attr_accessor :hostname, :directory

    VHOST_CONF_FILE = "/etc/apache2/extra/httpd-vhosts.conf".freeze
    VHOST_CONF_FILE_BACKUP = "#{VHOST_CONF_FILE}.backup".freeze
    HOSTS_FILE = "/etc/hosts".freeze
    HOSTS_FILE_BACKUP = "#{HOSTS_FILE}.backup".freeze

    def initialize(host, dir)
      @hostname = host
      @directory = dir
    end

    def self.restart_apache
      `sudo apachectl restart`
      say "Apache restarted."
      true
    end

    def self.backup_vhost
      File.delete(VHOST_CONF_FILE_BACKUP) if File.exist?(VHOST_CONF_FILE_BACKUP)
      FileUtils.cp VHOST_CONF_FILE, VHOST_CONF_FILE_BACKUP
      File.delete(HOSTS_FILE_BACKUP) if File.exist?(HOSTS_FILE_BACKUP)
      FileUtils.cp HOSTS_FILE, HOSTS_FILE_BACKUP
      say "Backed up vhosts conf and hosts file. Use `pave vh:restore` to restore them."
    end

    def self.restore_vhost
      return say "Couldn't find vhosts backup." unless File.exist?(VHOST_CONF_FILE_BACKUP)
      File.delete(VHOST_CONF_FILE)
      FileUtils.cp VHOST_CONF_FILE_BACKUP, VHOST_CONF_FILE

      return say "Couldn't find host file backup." unless File.exist?(HOSTS_FILE_BACKUP)
      File.delete(HOSTS_FILE)
      FileUtils.cp HOSTS_FILE_BACKUP, HOSTS_FILE

      restart_apache

      say "Restored vhosts conf and host file."
    end

    def create_vhost
      return say "No virtual host backup found. Run `pave vh:backup` before adding a virtual host." unless check_backup
      return say "No host name provided. Run `pave help` for more details." unless hostname.size > 0

      add_vhost_to_conf && add_hosts_entry && self.class.restart_apache && say("Created virtual host for #{hostname}.")
    end

    def remove_vhost
      return say "No virtual host backup found. Run `pave vh:backup` before adding a virtual host." unless check_backup

      remove_vhost_from_conf && remove_hosts_entry && self.class.restart_apache && say("Removed virtual host for #{hostname}.")
    end

    private

    def add_hosts_entry
      File.open(HOSTS_FILE, "a") do |f|
        f.puts "127.0.0.1 #{hostname}"
        f.puts "fe80::1%lo0 #{hostname}"
      end
      true
    end

    def remove_hosts_entry
      host_array = hosts_file_array.map do |line|
        if line.include?("127.0.0.1 #{hostname}") || line.include?("fe80::1%lo0 #{hostname}")
          nil
        else
          line
        end
      end

      File.open(HOSTS_FILE, "w") do |f|
        f.puts host_array.compact.join("\n")
      end
      true
    end

    def add_vhost_to_conf
      File.open(VHOST_CONF_FILE, "a") do |f|
        f.puts virtual_host_entry
      end
      true
    end

    def remove_vhost_from_conf
      vhost_array = vhosts_file_array
      vhost_line = vhost_array.index { |l| l.include?("ServerName \"#{hostname}\"") }
      if vhost_line
        # Sanity check
        return say("Error: vhost appears malformed. Couldn't find \"<Directory\" on line #{vhost_line + 2}") unless vhost_array[vhost_line - 6].include?("<Directory")
        return say("Error: vhost appears malformed. Couldn't find \"</VirtualHost>\" on line #{vhost_line + 2}") unless vhost_array[vhost_line + 2].include?("</VirtualHost")

        # Set all those lines to nil (so we can compact them later)
        ((vhost_line - 6)..(vhost_line + 3)).each {|i| vhost_array[i] = nil }
        File.open(VHOST_CONF_FILE, "w") do |f|
          f.puts vhost_array.compact.join("\n")
        end
        true
      else
        say "Didn't find #{hostname} in the vhost file."
        false
      end
    end

    def check_backup
      File.exist?(VHOST_CONF_FILE_BACKUP)
    end

    def virtual_host_entry
      "\n<Directory \"#{directory}\">\n" <<
      "  Allow From All\n" <<
      "  AllowOverride All\n" <<
      "  Options +Indexes\n" <<
      "</Directory>\n" <<
      "<VirtualHost *:80>\n" <<
      "  ServerName \"#{hostname}\"\n" <<
      "  DocumentRoot \"#{directory}\"\n" <<
      "</VirtualHost>\n"
    end

    def vhosts_file_array
      File.open(VHOST_CONF_FILE).map(&:rstrip)
    end

    def hosts_file_array
      File.open(HOSTS_FILE).map(&:rstrip)
    end

  end
end
