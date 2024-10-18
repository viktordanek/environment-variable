{
    inputs =
        {
            flake-utils.url = "github:numtide/flake-utils?rev=b1d9ab70662946ef0850d488da1c9019f3a9752a" ;
            nixpkgs.url = "github:NixOs/nixpkgs?rev=9afce28a1719e35c295fe8b379a491659acd9cd6" ;
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
                                                        observed='${ lib "myVar" }' &&
                                                            expected='${ builtins.concatStringsSep "" [ "$" "{" "myVar" "}" ] }' &&
                                                            if [ "$observed" != "$expected" ]
                                                            then
                                                                    exit 1
                                                            else
                                                                ${ pkgs.coreutils }/bin/mkdir $out
                                                            fi
                                                    ''
                                                ] ;
                                        } ;
                            } ;
                in flake-utils.lib.eachDefaultSystem fun ;
}
