{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = name : builtins.concatStringsSep "" [ "$" "{" (builtins.toString name) "}" ];
      in {
        lib = lib;

        checks.testLib = pkgs.stdenv.mkDerivation {
          name = "test-lib";
          builder = "${pkgs.bash}/bin/bash";
          args = [ "-c" ''
            set -e
            result='${lib "myVar"}'  # Pass "myVar" to lib as a parameter.
            expected='${ builtins.concatStringsSep "" [ "$" "{" "myVar" "}" ] }'

            if [ "$result" != "$expected" ]; then
              echo "Test failed: expected \"$expected\" but got \"$result\""
              exit 1
            else
                ${ pkgs.coreutils }/bin/mkdir $out &&
              echo "Test passed: $result"
            fi
          '' ];
        };
      }
    );
}
