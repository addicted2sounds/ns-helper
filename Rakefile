require_relative 'lib/shop_helper'
task default: %w[]

namespace :buyer do
  task :purchase do

  end
end
namespace :main do
  task :cms_site, :site do |t, args|
    helper(args[:site]).add_cms_site
  end
end

def helper(site=nil)
  env = ENV['NS_ENV'] || :dev
  site = site || ENV['NS_SITE']
  ShopHelper.new site.to_sym, env.to_sym
end