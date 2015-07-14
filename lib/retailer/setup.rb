
module Retailer
  module Setup
    def setup(credentials)
      login credentials
      signup
      set_about
      set_agreement
    end

    private
    def signup
      if has_css? '.edit_user'
        fill_in 'First Name', with: Faker::Name.first_name
        fill_in 'Last Name', with: Faker::Name.last_name
        fill_in 'Address', with: Faker::Address.street_address
        fill_in 'Postcode', with: Faker::Address.zip
        fill_in 'Town', with: Faker::Address.city
        fill_in 'Phone number', with: '7777777'
        check 'accept_docs'
        click_button 'Setup'
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
      end
    end
  end
end