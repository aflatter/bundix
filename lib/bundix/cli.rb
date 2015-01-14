require 'thor'
require 'bundix'
require 'fileutils'

class Bundix::CLI < Thor
  include Thor::Actions
  default_task :expr

  BUNDLER = "bundler"

  class Prefetch < Thor
    desc 'git URL REVISION', 'Prefetches a git repository'
    def git(url, revision)
      puts Prefetch::Wrapper.git(url, revision)
    end

    desc 'url URL', 'Prefetches a file from a URL'
    def url(url)
      puts Prefetcher::Wrapper.url(url)
    end
  end

  desc "init", "Sets up your project for use with Bundix"
  def init
    raise NotImplemented
  end

  desc 'expr', 'Creates a Nix expression for your project'
  option :gemfile, type: :string, default: 'Gemfile',
                   desc: "Path to the project's Gemfile"
  option :lockfile, type: :string,
                    desc: "Path to the project's Gemfile.lock"
  option :cachefile, type: :string, default: "#{ENV['HOME']}/.bundix/cache"
  option :target, type: :string, default: 'gemset.nix',
                  desc: 'Path to the target file'
  def expr
    require 'bundix/prefetcher'
    require 'bundix/manifest'

    lockfile = options[:lockfile]
    gemfile  = options[:gemfile]

    if lockfile == nil
      say('Using `bundler package --no-install` to generate Gemfile.lock', :green)
      lockfile = bundler_package(gemfile)
    else
      lockfile = Bundler::LockfileParser.new(Bundler.read_file(lockfile))
    end

    gems = Bundix::Prefetcher.new(shell).run(lockfile.specs, Pathname.new(options[:cachefile]))

    say("Writing...", :green)
    manifest = Bundix::Manifest.new(gems)
    create_file(@options[:target], manifest.to_nix, force: true)
  end

  desc 'prefetch', 'Conveniently wraps nix-prefetch-scripts'
  subcommand :prefetch, Prefetch

  desc 'dummy', 'dummy'
  def bundler_package(gemfile)
    project_dir = File.expand_path(gemfile.sub(/Gemfile$/, ""))
    lockfile = nil
    Dir.chdir(project_dir) do
      vendor_exists = File.exist?("vendor")
      lockfile_exists = File.exist?("Gemfile.lock")
      begin
        msg = `BUNDLE_IGNORE_CONFIG=true #{BUNDLER} package --no-install 2>&1`
        raise Thor::Error.new("bundler invokation failed:\n\n#{msg}") unless $?.success?
        lockfile = Bundler::LockfileParser.new(Bundler.read_file("Gemfile.lock"))
      ensure
        FileUtils.rm_r("vendor") rescue nil unless vendor_exists
        FileUtils.rm("Gemfile.lock") rescue nil unless lockfile_exists
      end
    end

    return lockfile
  end
end
