require 'bundler'

module Bundler
  extend self

  def setup(*args)
    Bundix.setup(*args)
  end

  # Disable the install command completely.
  class Installer
    def run(_)
      raise Bundler::InstallError, "Reload your Nix shell to install all gem dependencies"
    end
  end
end
