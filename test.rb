require './lib/shop_tester'
require_relative 'lib/db_helper'

# db_helper = DbHelper.new
# db_helper.restore_dump 'dumps/nowshop-02-07-2015.dump'
# db_helper.clone_staging

helper = ShopHelper.new(:saveur_shop, :dev)
# helper.add_cms_site
# helper.create_retailer
# helper.setup
helper.carrier.accept_products