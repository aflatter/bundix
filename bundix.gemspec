Gem::Specification.new do |s|
  s.name        = 'bundix'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.homepage    = 'https://github.com/cstrahan/bundix'
  s.summary     = "Creates Nix packages from Gemfiles."
  s.description = "Creates Nix packages from Gemfiles."
  s.authors     = ["Alexander Flatter" "Charles Strahan"]
  s.email       = 'rubycoder@example.com'
  s.files       = Dir["bin/*"] + Dir["lib/**/*.rb"]
  s.bindir      = "bin"
  s.add_runtime_dependency 'bundler', '~> 1.7.9'
  s.add_runtime_dependency 'thor',    '~> 0.19.1'
end
