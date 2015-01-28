{
  "bundix" = {
    version = "0.1.0";
    source = {
      type = "path";
      path = ./.;
      pathString = ".";
    };
    dependencies = [
      "bundler"
      "thor"
    ];
  };
  "bundler" = {
    version = "1.7.9";
    source = {
      type = "gem";
      sha256 = "1gd201rh17xykab9pbqp0dkxfm7b9jri02llyvmrc0c5bz2vhycm";
    };
  };
  "thor" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
}