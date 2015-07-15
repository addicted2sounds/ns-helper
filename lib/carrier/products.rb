module Carrier
  module Products
    def accept_products
      login @credentials
      click_link 'Approval' if has_link? 'Approval'
      all('.accept-btn').each { |btn| btn.click }
    end
  end
end