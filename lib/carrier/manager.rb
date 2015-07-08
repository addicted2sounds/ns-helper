require_relative 'products'
require_relative '../shared/login'

require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'faker'

module Carrier
  class Manager
    include Products
    include ShopOperations::Login

    def initialize(shop, credentials)
      @shop  = shop
      @site_params = @shop.site_params
      @credentials = credentials
    end
  end
end