require 'yaml'
require 'active_support/hash_with_indifferent_access'

module Settings
  class << self

    def load_config(filename, node)
      @_settings ||= Hash.new
      @_settings[node] = YAML::load_file(filename).deep_symbolize_keys
    end

    def method_missing(name)
      @_settings[name]
    end
  end
end