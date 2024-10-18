{
    inputs =
        {
            nixpkgs.url = "github:NixOS/nixpkgs" ;
            flake-utils.url = "github:numtide/flake-utils" ;
        } ;
    outputs =
        { self, nixpkgs, flake-utils, ... } :
            let
                fun =
                    system :
                    let
                        pkgs = import nixpkgs { inherit system; } ;
                        lib = name : builtins.concatStringsSep "" [ "$" "{" (builtins.toString name) "}" ] ;
                        in
                            {
                                lib = lib ;
                                checks.testLib =
                                    pkgs.stdenv.mkDerivation
                                        {
                                            name = "test-lib";
                                            builder = "${pkgs.bash}/bin/bash" ;
                                            args =
                                                [
                                                    "-c"
                                                    ''
                                                        observed='${lib "myVar"}' &&
                                                            expected='${ builtins.concatStringsSep "" [ "$" "{" "myVar" "}" ] }' &&
                                                            if [ "$observed != "$expected" ]
                                                            then
                                                                ${ pkgs.coreutils }/bin/echo "Test failed: expected \"$expected\" but got \"$result\"" &&
                                                                    exit 1
                                                            else
                                                                ${ pkgs.coreutils }/bin/mkdir $out &&
                                                                    ${ pkgs.coreutils }/bin/echo "Test passed: $result"
                                                            fi
                                                    ''
                                                ] ;
                                        } ;
                            } ;
                in flake-utils.lib.eachDefaultSystem fun ;
}
