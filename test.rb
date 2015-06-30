require './lib/shop_tester'


helper = ShopHelper.new(:saveur_shop, :dev)
helper.setup
# tester = ShopTester.new(:saveur_shop)
# tester.login as: :carrier
# helper.get_page(:index)