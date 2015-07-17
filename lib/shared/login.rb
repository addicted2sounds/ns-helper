module ShopOperations
  module Login
    include Capybara::DSL

    def login(credentials, **options)
      visit @site_params[:pages][:login]
      fill_in 'user_email', with: credentials[:email]
      fill_in 'user_password', with: credentials[:password]
      click_button 'Sign in'
    end
  end
end