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

    def create_retailer(**options)
      self.site ||=
      p site, credentials
      # login @credentials
      # click_link 'Carrier'
      # fill_in 'Email', with: credentials[:carrier][:email]
    end
  end
end