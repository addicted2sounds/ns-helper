require_relative '../base_manager'
require_relative 'setup'
require_relative '../shared/login'

module Retailer
  class Manager < BaseManager
    include Setup
    include ShopOperations::Login

    # def initialize(shop)
    #   @shop  = shop
    #   @site_params = @shop.site_params
    #   @credentials = @shop.site_credentials[:retailer]
    #   @log = @shop.log
    # end
  end
end