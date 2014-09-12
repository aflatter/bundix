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
        @sha256 or raise
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

    # The {Url} source is *not* very similar to `Bundler::Source::Rubygems`.
    # The latter describes a whole repository of gems while the former
    # is for a single gem. Because {Bundix::Source} is required to provide a
    # SHA256 checksum, describing the whole repository would mean downloading
    # all of rubygems.org.
    class Url < Base
      attr_reader :url

      def initialize(url, sha256 = nil)
        @url = url
        @sha256 = sha256
      end

      def components
        super + [url]
      end
    end
  end

  class Dependency
    def initialize(dependency)
      @dependency = dependency
    end

    def attr_name
      Bundix.to_attr_name(@dependency.name)
    end
  end

  class Gem
    attr_reader :source

    def initialize(spec, source)
      @spec = spec
      @source = source
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

    def dependencies
      @spec.dependencies.map { |dep| Dependency.new(dep) }
    end
  end
end
