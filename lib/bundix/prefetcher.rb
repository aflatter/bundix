require 'bundix'

class Bundix::Prefetcher
  require 'bundix/prefetcher/cache'
  require 'bundix/prefetcher/wrapper'

  attr_reader :wrapper
  attr_reader :shell

  def initialize(shell, wrapper = Wrapper)
    @shell = shell
    @wrapper = Wrapper
  end

  # @param [Bundler::SpecSet<Bundler::LazySpecification>] specs
  # @param [Pathname] cache_path
  # @return Array<Bundix::Gem>
  def run(specs, cache_path)
    cache = load_cache(cache_path)

    result = specs.map do |spec|
      source = build_source(spec)
      source.sha256 = if cache.has?(source)
                        shell.say_status('Cached', spec)
                        cache.get(source)
                      else
                        shell.say_status('Prefetching', spec)
                        prefetch(source)
                      end

      Bundix::Gem.new(spec, source)
    end

    write_cache(cache_path, result)

    result
  end

  def build_source(spec)
    source = spec.source
    case source
    when Bundler::Source::Rubygems
      url = File.join(source.remotes.first.to_s, 'downloads', "#{spec.name}-#{spec.version}.gem")
      Bundix::Source::Url.new(url)
    when Bundler::Source::Git
      Bundix::Source::Git.new(source.uri, source.revision)
    end
  end

  # @param [Pathname] cache_path
  # @return [Cache]
  def load_cache(cache_path)
    cache_path.exist? ? Cache.read(cache_path) : Cache.new
  end

  # @param [Bundler::LazySpecification] spec
  def prefetch(source)
    case source
    when Bundix::Source::Url
      wrapper.url(source.url)
    when Bundix::Source::Git
      wrapper.git(source.url, source.revision)
    end
  end

  # @param [Pathname] cache_path
  # @param [Array<Bundix::Gem>] gems
  def write_cache(cache_path, gems)
    cache_dir = cache_path.dirname
    cache_dir.mkpath unless cache_dir.exist?

    cache = Cache.new
    gems.map(&:source).each { |source| cache.set(source) }
    cache.write(cache_path)
  end
end
