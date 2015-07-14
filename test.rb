require './lib/shop_tester'
require_relative 'lib/db_helper'

gi pgi

helper = ShopHelper.new(:saveur_shop, :dev)
# helper.add_cms_site
# helper.create_retailer
# helper.setup
helper.carrier.accept_products