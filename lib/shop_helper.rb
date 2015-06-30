require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'active_support/all'
require 'yaml'
require 'faker'

class ShopHelper
  SETTINGS = './settings.yml'
  SHOP_CONFIG = './config.yml'
  include Capybara::DSL

  def initialize(name, env)
    @name, @env = name, env
    @settings = YAML::load_file(SETTINGS).deep_symbolize_keys
    @params = YAML::load_file(SHOP_CONFIG).deep_symbolize_keys
    @credentials = YAML::load_file(@settings[:credentials_file]).deep_symbolize_keys
    @site_credentials = @credentials[name][env]
    # @credentials = YAML::load_file(@settings[:credentials_file])[name.to_s].deep_symbolize_keys
    @site_params = @params[name]
    capybara_config
    @log = Logger.new(STDOUT)
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

  def login_main
    visit @params[:main][@env][:url]
    click_link 'Sign in'
    fill_in 'user_email', with: @credentials[:main][:admin][:email]
    fill_in 'user_password', with: @credentials[:main][:admin][:password]
    click_button 'Sign in'
  end
  def setup
    create_carrier
  end

  def create_carrier
    login_main
    click_link 'Carrier'
    fill_in 'user_email', with: @site_credentials[:carrier][:email]
    fill_in 'user_password', with: @site_credentials[:carrier][:password]
    fill_in 'user_profile_name', with: Faker::Name.name
    fill_in 'user_profile_bcc_email', with: @site_credentials[:carrier][:email]

    fill_in 'user_profile_paypal_api_username', with: @credentials[:paypal_api][:username]
    fill_in 'user_profile_paypal_api_password', with: @credentials[:paypal_api][:password]
    fill_in 'user_profile_paypal_api_signature', with: @credentials[:paypal_api][:signature]
    fill_in 'user_profile_paypal_api_app_id', with: @credentials[:paypal_api][:application_id]

    fill_in 'user_profile_annual_fee_amount', with: @site_params[:annual_fee]
    fill_in 'token_for_nowshop_domain', with: @site_params[:token]

    click_button 'Save'

    if page.has_content? 'New Carrier'
      save_sources('carrier')
      @log.warn 'Carrier creation failed. Review "carrier" screenshots'
      false
    else
      @log.info 'Carrier created'
      true
    end
  end
end