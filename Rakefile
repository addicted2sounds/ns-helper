require_relative 'lib/db_helper'
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
  task :create_carrier, :site do |t, args|
    site = args[:site].to_sym if args[:site]
    helper(args[:site]).admin.create_carrier Settings.credentials[site][env][:carrier],
                                              Settings.credentials[:paypal_api],
                                              Settings.config[site]
    Rake::Task['admin:cms_site'].invoke site
  end

  task :cms_site, :site do |t, args|
    site = args[:site].to_sym if args[:site]
    helper(args[:site]).admin.add_cms_site Settings.credentials[:main][env][:admin],
                                           Settings.config[site]
  end
end

namespace :carrier do
  task :accept_products, :site do |t, args|
    helper(args[:site]).carrier.accept_products
  end
end

namespace :retailer do
  task :create, :site do |t, args|
    site = args[:site].to_sym if args[:site]
    helper = helper(args[:site])
    helper.create_retailer
    helper(args[:site]).retailer.setup Settings.credentials[site][env][:retailer]
  end

  task :setup, :site do |t, args|
    site = args[:site].to_sym if args[:site]
    helper = helper(args[:site])
    helper.retailer.setup Settings.credentials[site][env][:retailer]
  end
end

namespace :db do
  task :sync do
    DbHelper.new.clone_staging
  end
  task :load, :filename do |t, args|
    filename = 'data/' + args[:filename]
    DbHelper.new.restore_dump filename
  end
end
def helper(site=nil)
  @site = site || ENV['NS_SITE']
  ShopHelper.new site.to_sym, env.to_sym
end

def env
  env = ENV['NS_ENV'] || :dev
  env.to_sym
end