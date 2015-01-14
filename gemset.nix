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
    version = "1.7.9";
    src = {
      type = "git";
      url = "https://github.com/bundler/bundler.git";
      rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
      fetchSubmodules = false;
      sha256 = "1f0isjrn4rwak3q6sbs6v6gqhwln32gv2dbd98r902nkg9i7y5i0";
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