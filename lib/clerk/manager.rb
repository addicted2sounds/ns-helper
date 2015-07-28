require_relative '../base_manager'

module Clerk
  class Manager < BaseManager
    attr_accessor :sites
    def login(credentials=nil)
      credentials ||= @credentials
      visit @options[:url]
      fill_in 'Email', with: credentials[:email]
      fill_in 'Password', with: credentials[:password]
      click_button 'Login'
      @logged_in = !has_content?('Password Incorrect')
    end

    def setup
      login_required
      @sites.each do |location, store|
        set_site store[:name]
        set_templates store[:templates]
        # Logger.info "#{store} selected"
        # sleep 10
        # site[:templates].each do |name, params|
        #   create_template name, params
        # end
      end
      # login
    end


    def set_site(name)
      login_required
      # Capybara.current_session.driver.browser.manage.window.resize_to 1024, 1500
      find('#navigation-header').hover
      css_store_tag = '#navigation-header div'
      create_store(name) unless has_css?(css_store_tag, text: name, exact: true)
      execute_script("document.getElementById('navigation-header').scrollTo(0, 40000)")
      @stores = all(css_store_tag).collect { |x| x.text }
      execute_script("document.getElementById('navigation-header').scrollBy(0, 48 * #{@stores.index(name)})")
      find(css_store_tag, text: name, exact: true).click
    end

    def create_store(name)
      visit "#{@options[:url]}/#/account/create"
      fill_in 'Store Name', with: name
      click_button 'Create'
    end

    def set_feed(url)
      click_link('Data sync')
      fill_in 'JSON Feed URL', with: url
      click_button 'Update settings'
    end

    def set_templates(templates)
      click_link 'Templates'
      sleep 1
      @current_templates = page.all('td:first-child').collect { |row| row.text.to_sym }
      p @current_templates
      templates.each do |template|
        if @current_templates.include? template[0]
          page.all(:link, 'Edit')[@current_templates.index(template[0])].click
        else

          p @current_templates.index(template[0])
      #     # page.all(:link, 'Edit')[@current_templates[template[0]]]
        end
        # choose template[1][:type]
        find(".api_option input[value='#{template[1][:type]}']").click
        fill_in 'Limit', with: template[1][:limit]
        click_button 'Edit product code'
        sleep 1
        execute_script('window.scrollTo(0,0)')
        find(:xpath, '//div[@id="full-screen-editor"]').native.send_keys 'aaa'
        save_screenshot 'tmp/123.png'
        # sleep 3
        click_button 'Done'
        sleep 6
      end

      # @current_templates = all('#content table')#.collect{|x| x.text}
      # @current_templates = first('#content table:first-child tbody tr td:first-child').text#.collect{|x| x.text}
      # p @current_templates#[0].text
    end

    def create_template(name, params)
      click_link 'Templates'
      click_link 'Create new template'
      fill_in 'Template Name', with: name.to_s
      click_button 'Create template'
    end

    # def element_position(id)
    #   page.driver.evaluate_script <<-EOS
    #     function() {
    #       var ele  = document.getElementById('#{id}');
    #       var rect = ele.getBoundingClientRect();
    #       return [rect.left, rect.top];
    #     }();
    #   EOS
    # end
  end
end