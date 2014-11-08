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
        @sha256 || "NO SHA256"
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

      def initialize(url, revision, sha256 = nil)
        @url = url
        @revision = revision
        @sha256 = sha256
      end

      def components
        super +  [url, revision]
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

      def components
        super +  [path]
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

    def attr_name
      Bundix.to_attr_name(@dependency.name)
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

    def attr_name
      Bundix.to_attr_name(@spec.name)
    end

    def drv_name
      "#{@spec.name}-#{version}"
    end

    def version
      @spec.version.to_s
    end
  end
end
