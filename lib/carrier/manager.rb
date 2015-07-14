require_relative 'products'
require_relative '../base_manager'
require_relative '../shared/login'

require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'faker'

module Carrier
  class Manager < BaseManager
    include Products
    include ShopOperations::Login

    def register

    end
  end
end