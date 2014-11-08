{
  bundix = {
    version = "0.1.0";
    src = {
      type = "path";
      path = ./.;
    };
    dependencies = [
      "bundler"
      "thor"
    ];
  };
  bundler = {
    version = "1.7.4";
    src = {
      type = "gem";
      sha256 = "122k07z60780mr00zfbbw04v9xlw1fhxjsx4g2rbm66hxlnlnh89";
    };
  };
  thor = {
    version = "0.19.1";
    src = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
}