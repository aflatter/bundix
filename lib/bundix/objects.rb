require 'bundix'

module Bundix
  # The {Source} class represents all information necessary to fetch the source
  # of one or more gems as required by a Nix derivation.
  module Source
    class Base
      attr_writer :sha256

      def initialize
        raise NotImplementedError
      end

      def sha256
        @sha256 ||= nil
      end

      def type
        self.class.name.split('::').last.downcase
      end

      def components
        [type]
      end

      def hash
        components.hash
      end
    end

    class Git < Base
      attr_reader :url
      attr_reader :revision
      attr_reader :submodules

      def initialize(url, revision, submodules, sha256 = nil)
        @url = url
        @revision = revision
        @submodules = submodules
        @sha256 = sha256
      end

      def components
        super + [{
          "url" => url,
          "revision" => revision,
          "submodules" => submodules
        }]
      end
    end

    class Gem < Base
      attr_reader :url

      def initialize(url, sha256 = nil)
        @url = url
        @sha256 = sha256
      end

      def components
        super + [url]
      end
    end

    class Path < Base
      attr_reader :path

      def initialize(path)
        @path = path
      end
    end
  end

  class Dependency
    def initialize(dependency)
      @dependency = dependency
    end

    def name
      @dependency.name
    end
  end

  class Gem
    attr_reader :source
    attr_reader :dependencies

    def initialize(spec, source, dependencies)
      @spec = spec
      @source = source
      @dependencies = dependencies
    end

    def name
      @spec.name
    end

    def drv_name
      "#{@spec.name}-#{version}"
    end

    def version
      @spec.version.to_s
    end
  end
end
