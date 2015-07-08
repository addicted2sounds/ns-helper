module Carrier
  module Products
    def accept_products
      login @credentials
      all('.accept-btn').each { |btn| btn.click }
    end
  end
end