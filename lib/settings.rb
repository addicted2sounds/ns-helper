require 'yaml'
require 'active_support/hash_with_indifferent_access'

module Settings
  def self.read(filename)
    @config = YAML::load_file(filename).deep_symbolize_keys
  end
end