let
  pkgs = import <nixpkgs> {};
  ruby = pkgs.ruby_2_1_3.override { cursesSupport = true; };
  loadRubyEnv = pkgs.loadRubyEnv;

  gemset = loadRubyEnv {
    inherit ruby;
    gemset = ./gemset.nix;
  };

in

gemset.bundix
