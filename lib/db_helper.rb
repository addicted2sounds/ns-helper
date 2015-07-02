require_relative 'settings'

class DbHelper
  attr_accessor :command_line
  def initialize
    @db = Settings.read('database.yml')
    @settings = Settings.read 'settings.yml'

  end
  def dump_staging
    filename = "dumps/nowshop-#{Time.now.strftime "%d-%m-%Y"}.dump"
    cmd = "ssh #{@settings[:staging_host]} -C 'pg_dump -Fc -h #{@db[:staging][:host]}"\
      " -U#{@db[:staging][:username]} -p5432 #{@db[:staging][:database]}' > #{filename}"
    system cmd
    filename
  end
  def restore_dump(filename)
    system "dropdb -U postgres #{@db[:dev][:database]}"
    system "createdb -U postgres -E UTF8 #{@db[:dev][:database]}"
    system "pg_restore --verbose --clean --jobs 4 -h localhost -U postgres -d #{@db[:dev][:database]} #{filename}"
  end
  def clone_staging
    restore_dump dump_staging
  end
end