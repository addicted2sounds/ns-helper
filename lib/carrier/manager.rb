require_relative '../shared/login'

require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'faker'

module Carrier
  class Manager
    include Setup

    def initialize(shop, credentials)
      @shop  = shop
      @site_params = @shop.site_params
      @credentials = credentials
    end
  end
end