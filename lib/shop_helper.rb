require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'
require 'active_support/all'
require 'yaml'
require 'faker'

require_relative 'settings'
require_relative 'carrier/manager'
require_relative 'retailer/manager'
require_relative 'admin/manager'
require_relative 'shared/login'

class ShopHelper
  SETTINGS = 'config/settings.yml'
  SHOP_CONFIG = 'config/config.yml'
  include Capybara::DSL
  include ShopOperations::Login
  attr_accessor :site_params


  # ROLES = [:carrier, :retailer]
  # ROLES.each do |role|
  #   define_method role do
  #     var = self.instance_variable_get "@#{role}"
  #     Object.const_get(role.capitalize)::Manager.new(self) if var.nil?
  #   end
  # end
  def carrier
    unless @retailer
      @carrier = Carrier::Manager.new self,
                            @credentials[@name][@env][:carrier],
                            @options[@name]
    end
    @carrier
  end
  def retailer
    unless @retailer
      @retailer = Retailer::Manager.new self,
                                        @credentials[@name][@env][:retailer],
                                        @options[@name]
      @retailer.paypal_callbacks = Settings.common[:paypal_callbacks]
    end
    @retailer
  end

  def clerk
    @clerk ||= Clerk::Manager.new(self, @credentials[:clerk], @settings[:clerk])
  end

  def admin
    p @credentials[:main][@env][:admin],
      @options[:main][@env]
    @admin ||= Admin::Manager.new @credentials[:main][@env][:admin],
                                  @options[:main][@env]
  end

  def initialize(name, env)
    @name, @env = name, env
    # @settings = YAML::load_file(SETTINGS).deep_symbolize_keys
    @settings = Settings.load_config SETTINGS, :config
    @options = Settings.load_config SHOP_CONFIG, :common
    # @options = YAML::load_file(SHOP_CONFIG).deep_symbolize_keys
    @credentials = YAML::load_file(@settings[:credentials_file]).deep_symbolize_keys
    @site_credentials = @credentials[name][env]
    # @credentials = YAML::load_file(@settings[:credentials_file])[name.to_s].deep_symbolize_keys
    @site_params = @options[name]
    capybara_config

    @log = Logger.new(STDOUT)
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
    Capybara.app_host = @site_params[@env][:url]
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



  def login_main(credentials)
    visit @options[:main][@env][:url]
    click_link 'Sign in'
    fill_in 'user_email', with: credentials[:email]
    fill_in 'user_password', with: credentials[:password]
    click_button 'Sign in'
  end

  def setup
    @retailer_manager = Retailer::Manager.new(self)
    @retailer_manager.setup @credentials[@name][@env][:retailer]
    # retailer_about
  end

  def retailer_setup
    login @credentials[@name][@env][:retailer]
    fill_in 'First Name', with: Faker::Name.first_name
    fill_in 'Last Name', with: Faker::Name.first_name
    fill_in 'Address', with: Faker::Address.street_address
    fill_in 'Postcode', with: Faker::Address.zip
    fill_in 'Town', with: Faker::Address.city
    fill_in 'Phone number', with: Faker::PhoneNumber.phone_number.gsub('.', '-')
    check 'accept_docs'
    click_button 'Setup'
    if has_content? 'Setup your account'
      save_sources('retailer-setup')
      @log.warn 'Retails setup failed. Review "retailer-setup" screenshots'
      false
    else
      @log.info 'Retails setup succeed'
      true
    end
  end

  def retailer_about
    login @credentials[@name][@env][:retailer]
    # fill_in 'About', with:
  end

  def create_retailer
    login_main @credentials[@name][@env][:carrier]
    if has_content? 'Registration'
      fill_in 'First Name', with: Faker::Name.first_name
      fill_in 'Last Name', with: Faker::Name.first_name
      fill_in 'Address', with: Faker::Address.street_address
      fill_in 'Zip code', with: Faker::Address.zip
      fill_in 'Company', with: Faker::Company.name
      fill_in 'Website URL', with: Faker::Internet.domain_name
      fill_in 'City', with: Faker::Address.city
      fill_in 'Telephone', with: Faker::PhoneNumber.phone_number
      click_button 'Register'
    end
    login @credentials[@name][@env][:carrier]
    click_link 'New retailer'
    fill_in 'Email', with: @credentials[@name][@env][:retailer][:email]
    fill_in 'Password', with: @credentials[@name][@env][:retailer][:password]
    fill_in 'Company Name', with: Faker::Company.name
    click_button 'Send'
  end

  def add_cms_site
    # p Settings.credentials[:main][@env][:admin]
    # login Settings.credentials[:main][@env][:admin]
    # click_link 'Sites'
    # click_link 'Create a new site'
    # fill_in 'site_host', with: @site_params[@env][:host]
    # fill_in 'site_name', with: @site_params[@env][:name]
    # click_button 'Save'
    # if page.has_content? 'has already been taken'
    #   save_sources('cms_site')
    #   @log.warn 'Site addition failed. Review "cms_site" screenshots'
    #   false
    # else
    #   @log.info 'Cms site added'
    #   true
    # end
  end

  def create_carrier
    login_main @credentials[:main][:admin]
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