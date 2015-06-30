require './lib/shop_helper'

class ShopTester
  def initialize(name)
    @shop = ShopHelper.new(name)
  end

  def login(**options)
    role = options.fetch :as, :carrier
    @shop.login(role)
  end
end