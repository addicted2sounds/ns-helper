require_relative 'settings'

class DbHelper
  attr_accessor :command_line
  def initialize
    @db = Settings.read('database.yml')[:staging]
    @settings = Settings.read 'settings.yml'

  end
  def dump_staging
    filename = "dumps/nowshop-#{Time.now.strftime "%d-%m-%Y"}"
    cmd = "ssh #{@settings[:staging_host]} -C 'pg_dump  -h #{@db[:host]}"\
      " -U#{@db[:username]} -p5432 #{@db[:database]}' > #{filename}.dump"
    system cmd
  end
end