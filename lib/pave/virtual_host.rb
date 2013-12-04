require "pave/shell"
require "fileutils"

module Pave
  class VirtualHost
    include Pave::Shell

    attr_accessor :hostname

    def initialize(host)
      @hostname = host
    end

    def restart_apache
      `sudo apachectl restart`
      say "Apache restarted."
      true
    end

    def backup_vhost
      File.delete(vhosts_conf_file_backup) if File.exist?(vhosts_conf_file_backup)
      FileUtils.cp vhosts_conf_file, vhosts_conf_file_backup
      File.delete(hosts_file_backup) if File.exist?(hosts_file_backup)
      FileUtils.cp hosts_file, hosts_file_backup
      say "Backed up vhosts conf and hosts file. Use `pave vh:restore` to restore them."
    end

    def restore_vhost
      return say "Couldn't find vhosts backup." unless File.exist?(vhosts_conf_file_backup)
      File.delete(vhosts_conf_file)
      FileUtils.cp vhosts_conf_file_backup, vhosts_conf_file

      return say "Couldn't find host file backup." unless File.exist?(hosts_file_backup)
      File.delete(hosts_file)
      FileUtils.cp hosts_file_backup, hosts_file

      restart_apache

      say "Restored vhosts conf and host file."
    end

    def create_vhost
      return say "No virtual host backup found. Run `pave vh:backup` before adding a virtual host." unless check_backup
      return say "No host name provided. Run `pave help` for more details." unless hostname.size > 0

      add_vhost_to_conf && add_hosts_entry && restart_apache && say("Created virtual host for #{hostname}.")
    end

    def remove_vhost
      return say "No virtual host backup found. Run `pave vh:backup` before adding a virtual host." unless check_backup

      remove_vhost_from_conf && remove_hosts_entry && restart_apache && say("Removed virtual host for #{hostname}.")
    end

    private

    def add_hosts_entry
      File.open(hosts_file, "a") do |f|
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

      File.open(hosts_file, "w") do |f|
        f.puts host_array.compact.join("\n")
      end
      true
    end

    def add_vhost_to_conf
      File.open(vhosts_conf_file, "a") do |f|
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
        File.open(vhosts_conf_file, "w") do |f|
          f.puts vhost_array.compact.join("\n")
        end
        true
      else
        say "Didn't find #{hostname} in the vhost file."
        false
      end
    end

    def check_backup
      File.exist?(vhosts_conf_file_backup)
    end

    def virtual_host_entry
      "\n<Directory \"#{project_folder}\">\n" <<
      "  Allow From All\n" <<
      "  AllowOverride All\n" <<
      "  Options +Indexes\n" <<
      "</Directory>\n" <<
      "<VirtualHost *:80>\n" <<
      "  ServerName \"#{hostname}\"\n" <<
      "  DocumentRoot \"#{project_folder}\"\n" <<
      "</VirtualHost>\n"
    end

    def project_folder
      Dir.pwd
    end

    def vhosts_file_array
      File.open(vhosts_conf_file).map {|l| l.rstrip}
    end

    def hosts_file_array
      File.open(hosts_file).map {|l| l.rstrip}
    end

    def vhosts_conf_file
      "/etc/apache2/extra/httpd-vhosts.conf"
    end

    def vhosts_conf_file_backup
      vhosts_conf_file + ".backup"
    end

    def hosts_file
      "/etc/hosts"
    end

    def hosts_file_backup
      hosts_file + ".backup"
    end

  end
end
