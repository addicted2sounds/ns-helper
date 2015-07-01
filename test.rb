require './lib/shop_tester'
require_relative 'lib/db_helper'

db_helper = DbHelper.new
db_helper.dump_staging
# helper = ShopHelper.new(:saveur_shop, :dev)
# helper.setup
# tester = ShopTester.new(:saveur_shop)
# tester.login as: :carrier
# helper.get_page(:index)