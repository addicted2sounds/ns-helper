require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'active_support/all'
require 'yaml'

class ShopHelper
  SETTINGS = './settings.yml'
  SHOP_CONFIG = './config.yml'
  include Capybara::DSL

  def initialize(name)
    @name = name
    @settings = YAML::load_file(SETTINGS).deep_symbolize_keys
    @params = YAML::load_file(SHOP_CONFIG).deep_symbolize_keys
    @credentials = YAML::load_file(@settings[:credentials_file])[name.to_s].deep_symbolize_keys
    @site_params = @params[name]
    capybara_config
    #  # change url
  end

  def capybara_config
    Capybara.configure do |config|
      config.run_server = false
      config.default_driver = @settings[:capybara_driver].to_sym
    end
    if @settings[:capybara_driver] == 'webkit'
      page.driver.browser.header('User-Agent', @settings[:user_agent])
      page.driver.allow_url('*')
    end
    Capybara.app_host = @site_params[:url]
  end

  def get_page(page)
    visit @site_params[:pages][page]
    save_sources(page)
  end

  def save_sources(page_name)
    Capybara.save_and_open_page_path = "#{@settings[:screenshot_path]}/#{@name}/#{page_name}"
    screenshot_and_save_page
    # screenshot_and_save_page "#{SCREEN_SHOTS_PATH}/#{@name}/#{page_name}.png"
  end

  def login(role)
    visit @site_params[:pages][:login]
    save_sources(:login)
    # page.fill_in 'user_email', with: @credentials[role][:email]
    # page.fill_in 'user_password', with: @credentials[role][:password]

  end
end