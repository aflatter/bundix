with (import <nixpkgs> {});

runCommand "dummy" {
  buildInputs = [ ruby_2_1_3 bundler_HEAD ];
  shellHook = ''
    export GEM_HOME=$HOME/.gem/ruby/2.1.3
    mkdir -p $GEM_HOME
  '';
} ''

''
