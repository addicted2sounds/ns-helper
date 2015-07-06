require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'faker'

class BaseManager
  include Capybara::DSL

  def initialize(shop, **options)
    @shop, @options, @credentials  = shop, options, credentials
    @site_params = @shop.site_params
  end

end