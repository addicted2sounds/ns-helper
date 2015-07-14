require_relative '../base_manager'

module Admin
  class Manager < BaseManager
    def initialize(credentials, **options)
      @credentials, @options = credentials, options
    end

    def login(credentials)
      visit @options[:url]
      click_link 'Sign in'
      fill_in 'user_email', with: credentials[:email]
      fill_in 'user_password', with: credentials[:password]
      click_button 'Sign in'
    end

    def create_retailer(credentials, pp_api, **options)
      login @credentials
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