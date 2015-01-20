require 'bundix'
require 'pathname'

class Bundix::Manifest
  attr_reader :gems

  def initialize(gems, lockfile, target)
    @lockfile = Pathname.new(lockfile).expand_path
    @target = Pathname.new(target).expand_path
    @gems = gems.sort_by { |g| g.name }
  end

  def relative_path(path)
    path = Pathname.new(path)
    path = @lockfile.dirname + path if path.relative?
    path = path.relative_path_from(@target.dirname)

    "./#{path.to_s}"
  end

  def to_nix
    template = File.read(__FILE__).split('__END__').last.strip
    ERB.new(template, nil, '->').result(binding)
  end
end

__END__
{
  <%- gems.each do |gem| -%>
  <%= gem.name.inspect %> = {
    version = "<%= gem.version %>";
    source = {
      type = "<%= gem.source.type %>";
      <%- if gem.source.type == 'git' -%>
      url = "<%= gem.source.url %>";
      rev = "<%= gem.source.revision %>";
      fetchSubmodules = <%= gem.source.submodules %>;
      sha256 = "<%= gem.source.sha256 %>";
      <%- elsif gem.source.type == 'gem' -%>
      sha256 = "<%= gem.source.sha256 %>";
      <%- elsif gem.source.type == 'path' -%>
      path = <%= relative_path(gem.source.path) %>;
      <%- end -%>
    };
    <%- if gem.dependencies.any? -%>
    dependencies = [
      <%= gem.dependencies.sort.map {|d| d.inspect}.join("\n      ") %>
    ];
    <%- end -%>
  };
  <%- end -%>
}
