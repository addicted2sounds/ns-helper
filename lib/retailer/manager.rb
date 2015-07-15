require_relative '../base_manager'
require_relative 'setup'
require_relative '../shared/login'

module Retailer
  class Manager < BaseManager
    attr_writer :paypal_callbacks
    include Setup
    include ShopOperations::Login
  end
end