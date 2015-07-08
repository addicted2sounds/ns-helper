require_relative 'setup'
require_relative '../shared/login'

require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'faker'

module Retailer
  class Manager
    include Setup
    include ShopOperations::Login

    def initialize(shop)
      @shop  = shop
      @site_params = @shop.site_params
      @credentials = @shop.site_credentials[:retailer]
      @log = @shop.log
    end
  end
end