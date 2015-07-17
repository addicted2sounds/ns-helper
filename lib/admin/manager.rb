require_relative '../base_manager'

module Admin
  class Manager < BaseManager
    include ShopOperations::Login
    def initialize(credentials, **options)
      @credentials, @options = credentials, options
    end

    def login_main(credentials)
      visit @options[:url]
      click_link 'Sign in'
      fill_in 'user_email', with: credentials[:email]
      fill_in 'user_password', with: credentials[:password]
      click_button 'Sign in'
    end

    def add_cms_site(credentials, options)
      p @shop, @options
      # p Settings.credentials[:main][@env][:admin], credentials
      # login credentials
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

    def create_carrier(credentials, pp_api, **options)
      login_main @credentials
      click_link 'Carrier'
      within '#new_user' do
        fill_in 'user_email', with: credentials[:email]
        fill_in 'user_password', with: credentials[:password]
        fill_in 'Name', with: options[:dev][:name] # be sure change env later
        fill_in 'user_profile_bcc_email', with: credentials[:email]

        fill_in 'user_profile_paypal_api_username', with: pp_api[:username]
        fill_in 'user_profile_paypal_api_password', with: pp_api[:password]
        fill_in 'user_profile_paypal_api_signature', with: pp_api[:signature]
        fill_in 'user_profile_paypal_api_app_id', with: pp_api[:application_id]

        fill_in 'user_profile_annual_fee_amount', with: options[:annual_fee]
        fill_in 'token_for_nowshop_domain', with: options[:token]

        click_button 'Save'
      end
    end
  end
end