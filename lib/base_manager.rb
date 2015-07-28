require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'faker'

class BaseManager
  include Capybara::DSL
  attr_accessor :env
  def initialize(shop, credentials=nil, **options)
    @shop, @options, @credentials  = shop, options, credentials
    @site_params = @shop.site_params
  end

  def login_required
    self.send(:login) unless @logged_in
  end
end