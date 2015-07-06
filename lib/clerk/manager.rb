module Clerk
  class Manager
    def initialize(shop, **options)
      @shop, @options  = shop, options
      @site_params = @shop.site_params
    end

    def login(credentials)
      visit @options[:url]
    end
  end
end