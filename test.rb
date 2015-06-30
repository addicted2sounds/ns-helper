require './lib/shop_tester'

tester = ShopTester.new(:saveur_shop)
tester.login as: :carrier
# helper.get_page(:index)