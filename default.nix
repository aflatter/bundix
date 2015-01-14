let
  pkgs = import <nixpkgs> {};
  ruby = pkgs.ruby_2_1_3.override { cursesSupport = true; };
  loadRubyEnv = pkgs.loadRubyEnv;

  gemset = loadRubyEnv {
    inherit ruby;
    gemset = ./gemset.nix;
    fixes = {
      bundix = attrs: {
        postBuild = ''
          substituteInPlace lib/bundix/cli.rb \
            --replace 'BUNDLER = "bundler"' \
                      'BUNDLER = "${pkgs.bundler_HEAD}/bin/bundle"'
        '';
      };
    };
  };

in

gemset.bundix
