require_relative '../base_manager'

module Buyer
  class Manager < BaseManager
    def initialize(shop, credentials=nil)
      @shop  = shop
      @site_params = @shop.site_params
      @credentials = credentials
    end

    def purchase(path)
      visit path
      find('.add_to_cart_go_to_checkout').click
      find('.checkout-btn.paypal').click
      fill_in 'Email', with: @credentials[:paypal][:email]
      fill_in 'PayPal password', with: @credentials[:paypal][:password]
      click_button 'Log In'
      first('#continue_abovefold').click
    end
  end
end
