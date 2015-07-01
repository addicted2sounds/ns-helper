require_relative 'settings'

class DbHelper
  attr_accessor :command_line
  def initialize
    db = Settings.read('database.yml')[:staging]
    settings = Settings.read 'settings.yml'
    cmd = "ssh #{settings[:staging_host]} -C 'pg_dump  -h #{db[:config]} -U#{db[:user]} -p5432 #{db[:database]}' > db.dump"
  end
  def dump_staging
    p CMD_DUMP
  end
end