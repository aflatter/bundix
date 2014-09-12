require 'thor'
require 'bundix'

class Bundix::CLI < Thor
  include Thor::Actions
  default_task :expr

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
  option :lockfile, type: :string, default: 'Gemfile.lock',
                    desc: "Path to the project's Gemfile.lock"
  option :cachefile, type: :string, default: '.bundix/cache'
  option :target, type: :string, default: '.bundix/definition.nix',
                  desc: 'Path to the target file'
  def expr
    require 'bundix/prefetcher'
    require 'bundix/manifest'

    say("Defining your environment...", :green)
    definition = Bundler::Definition.build(options[:gemfile], options[:lockfile], {})

    ruby_version = definition.ruby_version.to_s
    say("Using #{ruby_version}") unless ruby_version.empty?

    gems = Bundix::Prefetcher.new(shell).run(definition.resolve, Pathname.new(options[:cachefile]))

    say("Writing...", :green)
    manifest = Bundix::Manifest.new(ruby_version, gems)
    create_file(@options[:target], manifest.to_nix, force: true)
  end

  desc 'prefetch', 'Conveniently wraps nix-prefetch-scripts'
  subcommand :prefetch, Prefetch
end
