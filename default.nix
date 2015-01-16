let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  ruby = pkgs.ruby_2_1_3.override { cursesSupport = true; };
  loadRubyEnv = pkgs.loadRubyEnv;

  filePredicate = path: lib.any (suff: lib.hasSuffix suff path) [
    ".rb"
    ".gemspec"
    "bundix"
  ];
  srcPredicate = path: type:
    (type == "directory" && !lib.hasSuffix ".git" path) || filePredicate path;
  src = builtins.filterSource srcPredicate ./.;

  gemset = loadRubyEnv {
    inherit ruby;
    gemset = ./gemset.nix;
    fixes.bundix = attrs: {
      inherit src;
    };
  };

in

gemset.bundix
