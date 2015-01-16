{
  "bundix" = {
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
  "bundler" = {
    version = "1.7.9";
    src = {
      type = "git";
      url = "https://github.com/cstrahan/bundler.git";
      rev = "b233205ec4b474e97c8dc40be9c53a41a70df0e3";
      fetchSubmodules = false;
      sha256 = "1681nnhga5nqslnx44a3y51vcdry51ya6fan0npfrkkmkv8xqr4z";
    };
  };
  "thor" = {
    version = "0.19.1";
    src = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
    dependencies = [
      "bundler"
    ];
  };
}
