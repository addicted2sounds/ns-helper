
module Retailer
  module Setup
    def setup(credentials)
      login credentials
      set_account
      set_about
      set_agreement
      set_payments
      upload_products
    end

    private

    def set_account
      if has_css? '.edit_user'
        fill_in 'First Name', with: Faker::Name.first_name
        fill_in 'Last Name', with: Faker::Name.first_name
        fill_in 'Address', with: Faker::Address.street_address
        fill_in 'Postcode', with: Faker::Address.zip
        fill_in 'Town', with: Faker::Address.city
        fill_in 'Phone number', with: Faker::PhoneNumber.phone_number.gsub('.', '-')
        check 'accept_docs'
        click_button 'Setup'
        if has_css? '.edit_user'
          @shop.save_sources('retailer-setup')
          @log.warn 'Retails setup failed. Review "retailer-setup" screenshots'
          false
        else
          @log.info 'Retails setup succeed'
          true
        end
      end
    end

    def set_about
      if has_css? '.about-retailer'
        fill_in 'shop_retailer_about', with: Faker::Lorem.sentence
        click_button 'Save'
      end
    end

    def set_agreement
      if has_css? '.agreement-form'
        click_button 'Create agreement'
        fill_in 'Email', with: @credentials[:paypal][:email]
        fill_in 'PayPal password', with: @credentials[:paypal][:password]
        click_button 'Log In'
        click_button 'Agree and Continue'
        visit "#{ @shop.settings[:paypal_callbacks][:agreement] }?#{ URI.parse(current_url).query }"
      end
    end

    def set_payments
      if has_css? '.payments-form'
        click_button 'Grant permissions'
        if has_css? '#loginBox'
          fill_in 'Email', with: @credentials[:paypal][:email]
          fill_in 'Password', with: @credentials[:paypal][:password]
          click_button 'Log In'
        end
        click_button 'Grant Permission'
        sleep 1 # Monkey patch for js redirection
        find '[name="GetAccessTokenRequest[verifier]"]'
        p "#{ @shop.settings[:paypal_callbacks][:permissions] }?#{ URI.parse(current_url).query }"
        using_wait_time 20000 do #really long request
          visit "#{ @shop.settings[:paypal_callbacks][:permissions] }?#{ URI.parse(current_url).query }"
        end
      end
    end

    def upload_products
      if has_css? '.retailer-products'
        click_link 'Upload CSV'
        attach_file 'csv_file', File.absolute_path(@shop.settings[:sample_products])
        click_button 'Upload'
        click_button 'Upload'
      end
    end
  end
end