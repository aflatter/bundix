require 'bundix'

class Bundix::Manifest
  attr_reader :gems
  attr_reader :ruby_version

  def initialize(ruby_version, gems)
    @ruby_version = ruby_version
    @gems = gems.sort_by { |g| g.name }
  end

  def to_nix
    template = File.read(__FILE__).split('__END__').last.strip
    ERB.new(template, nil, '->').result(binding)
  end
end

__END__
{
  <%- gems.each do |gem| -%>
  <%= gem.attr_name %> = {
    version = "<%= gem.version %>";
    src = {
      type = "<%= gem.source.type %>";
      <%- if gem.source.type == 'git' -%>
      url = "<%= gem.source.url %>";
      rev = "<%= gem.source.revision %>";
      sha256 = "<%= gem.source.sha256 %>";
      <%- elsif gem.source.type == 'gem' -%>
      sha256 = "<%= gem.source.sha256 %>";
      <%- elsif gem.source.type == 'path' -%>
      path = <%= gem.source.path %>;
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
