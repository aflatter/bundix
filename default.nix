let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  ruby = pkgs.ruby21;
  buildRubyGem = pkgs.ruby21Libs.buildRubyGem;

  thor = buildRubyGem {
    name = "thor-0.19.1";
    sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    dontBuild = true;
  };

  bundler = buildRubyGem {
    name = "bundler-1.7.2";
    sha256 = "1xfacbivyi40ig9jzpsv2z42vwghf77n4r65ls0pcnbqn4ypqyhc";
    dontBuild = true;
    dontPatchShebangs = true;
  };

in buildRubyGem rec {
  name = "bundix";
  buildInputs = [ ruby ];
  builder = ./builder.sh;
  gemPath = [ thor bundler ];
  src = ./.;

  cacert = pkgs.cacert;

  shellHook = ''
    #export PATH=${builtins.getEnv "PWD"}/bin:$PATH
    #export RUBYLIB=${builtins.getEnv "PWD"}/lib:$RUBYLIB
    export CURL_CA_BUNDLE=${cacert}/etc/ca-bundle.crt
    export PATH=/Users/aflatter/Development/bundix/bin:$PATH
    export RUBYLIB=/Users/aflatter/Development/bundix/lib:$RUBYLIB
  '';
}
