require './lib/shop_tester'
require_relative 'lib/db_helper'

# db_helper = DbHelper.new
# db_helper.clone_staging
# db_helper.restore_dump 'dumps/nowshop-02-07-2015.dump'

helper = ShopHelper.new(:saveur_shop, :dev)
# helper.create_retailer
# retailer = Retailer.new
helper.setup
# tester = ShopTester.new(:saveur_shop)
# tester.login as: :carrier
# helper.get_page(:index)