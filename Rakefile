require_relative 'lib/shop_helper'
require_relative 'lib/settings'

task default: %w[]

namespace :buyer do
  task :purchase do

  end
end
namespace :admin do
  task :add_retailer, :site do |t, args|
    Settings.read 'config/credentials.yml'
    # p Settings.config
    helper(args[:site]).admin.create_retailer
  end
  task :cms_site, :site do |t, args|
    helper(args[:site]).add_cms_site
  end
end

def helper(site=nil)
  env = ENV['NS_ENV'] || :dev
  site = site || ENV['NS_SITE']
  ShopHelper.new site.to_sym, env.to_sym
end