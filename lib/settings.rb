require 'yaml'
require 'active_support/hash_with_indifferent_access'

module Settings
  class << self
    attr_accessor :config
    def load_config(filename, node)
      @config ||= Hash.new
      @config[node] = YAML::load_file(filename).deep_symbolize_keys
    end
  end
end