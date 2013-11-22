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
      sh "mysql -u root -e 'CREATE DATABASE #{name}'"
    end

    def dump
      say "Creating dump of #{name} at #{Dir.getwd}/#{Time.now.strftime("%Y-%m-%d")}-#{name}.sql.gz"
      sh "mysqldump -u root #{name} | gzip > #{Time.now.strftime("%Y-%m-%d")}-#{name}.sql.gz"
    end
  end
end
