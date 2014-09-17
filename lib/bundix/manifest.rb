require 'bundix'

class Bundix::Manifest
  attr_reader :gems
  attr_reader :ruby_version

  def initialize(ruby_version, gems)
    @ruby_version = ruby_version
    @gems = gems
  end

  def to_nix
    template = File.read(__FILE__).split('__END__').last.strip
    ERB.new(template, nil, '->').result(binding)
  end
end

__END__
{
  <%- if ruby_version && !ruby_version.empty? -%>
  rubyVersion = "<%= ruby_version %>";
  <%- end -%>
  gemset =  {
    <%- gems.each do |gem| -%>
    <%= gem.attr_name %> = {
      name = "<%= gem.drv_name %>";

      src = {
        type = "<%= gem.source.type %>";
        url = "<%= gem.source.url %>";
        <%- if gem.source.type == 'git' -%>
        rev = "<%= gem.source.revision %>";
        leaveDotGit = true;
        <%- end -%>
        sha256 = "<%= gem.source.sha256 %>";
      };
      <%- if gem.dependencies.any? -%>
      dependencies = [
        <%= gem.dependencies.map { |dep| %Q{"#{dep.attr_name}"} }.join("\n      ") %>
      ];
      <%- end -%>
    };
    <%- end -%>

    bundler = {
      name = "bundler-1.7.1";

      src = {
        type = "url";
        url = "https://rubygems.org/downloads/bundler-1.7.1.gem";
        sha256 = "144yqbmi89gl933rh8dv58bm7ia14s4a098qdi2z0q09ank9n5h2";
      };
    };
  };
}
