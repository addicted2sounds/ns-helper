require_relative 'lib/shop_helper'
require_relative 'lib/settings'

task default: %w[]

Settings.load_config 'config/credentials.yml', :credentials
Settings.load_config 'config/config.yml', :config

namespace :buyer do
  task :purchase do

  end
end

namespace :admin do
  task :add_retailer, :site do |t, args|
    site = args[:site].to_sym if args[:site]
    helper(args[:site]).admin.create_retailer Settings.credentials[site][env][:carrier],
                                              Settings.credentials[:paypal_api],
                                              Settings.config[site]
    Rake::Task['cms_site'].invoke site
  end
  task :cms_site, :site do |t, args|
    helper(args[:site]).add_cms_site
  end
end

namespace :retailer do
  task :create, :site do |t, args|
    site = args[:site].to_sym if args[:site]
    helper = helper(args[:site])
    # helper.create_retailer
    helper(args[:site]).retailer.setup Settings.credentials[site][env][:retailer]
  end
end

def helper(site=nil)
  @site = site || ENV['NS_SITE']
  ShopHelper.new site.to_sym, env.to_sym
end

def env
  ENV['NS_ENV'] || :dev
end