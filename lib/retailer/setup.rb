
module Retailer
  module Setup
    def setup(credentials)
      login credentials
      set_account
      # set_about
      # set_agreement
    end

    private

    def set_account
      if has_css? '.edit_user'

      end
    end

    def set_about
      if has_content? 'About You form'
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