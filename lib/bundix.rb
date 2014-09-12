require 'erb'
require 'pathname'

require 'bundix/bundler_ext'
require 'bundix/objects'

# Generates a Nix expression for bundler-managed dependencies.
module Bundix
  class << self
    def to_attr_name(str)
      # TODO: This could lead to naming conflicts. Investigate.
      str.gsub('.', '_')
    end
  end
end
