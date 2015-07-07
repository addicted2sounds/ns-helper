require_relative '../base_manager'

module Clerk
  class Manager < BaseManager
    def login(credentials=nil)
      credentials ||= @credentials
      visit @options[:url]
      fill_in 'Email', with: credentials[:email]
      fill_in 'Password', with: credentials[:password]
      click_button 'Login'
      @logged_in = !has_content?('Password Incorrect')
    end

    def set_site(name)
      login_required
      find('#navigation-header').hover
      if has_css?('#navigation-header div', text: name, exact: true)
        first('#navigation-header div', text: name, exact: true).click
      else
        first('#navigation-header div', text: 'NEW WEBSITE').click
        fill_in 'Name', name
        click_button 'Create'
      end
    end

    def set_feed(url)
      click_link('Data sync')
      fill_in 'JSON Feed URL', with: url
      click_button 'Update settings'
    end

    def set_templates(site, templates)
      set_site site
      click_link 'Templates'
    end
  end
end