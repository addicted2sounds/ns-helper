require_relative '../base_manager'

module Clerk
  class Manager < BaseManager
    def login(credentials=nil)
      credentials ||= @credentials
      visit @options[:url]
    end
  end
end