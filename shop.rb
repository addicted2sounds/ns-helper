#!/home/addicted/.rvm/bin/ruby
require 'optparse'
require_relative 'lib/shop_tester'

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [-db --retailer --]"

  opts.on('-d', '--sync-db', 'Run verbosely') do |v|
    p 'sync'
  end
end.parse!

# p options
# p ARGV

# helper = ShopHelper.new(:saveur_shop, :dev)
# helper.setup
# tester = ShopTester.new(:saveur_shop)
# tester.login as: :carrier
# helper.get_page(:index)