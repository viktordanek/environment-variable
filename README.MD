# Overview

This flake provides a simple solution for using Bash environment variables within NixOS configurations. By default, NixOS interprets ${} as a request for Nix expressions, which can lead to confusion when trying to access Bash variables. This flake allows you to correctly reference Bash environment variables in your NixOS configurations.
Usage

To reference a Bash environment variable in NixOS, use the following syntax:

nix

${ environment-variable environment variable }

# Example

If you have a Bash variable named MY_VAR, you would reference it in your NixOS configuration like this:

nix

someOption = "${ environment-variable MY_VAR }";

This will correctly evaluate to the value of MY_VAR in your NixOS setup.
Installation

To use this flake, add it to your flake.nix file. Make sure you have enabled experimental features in your Nix configuration to support flakes.

nix

{
inputs.flake-url.url = "git+https://your-repo-url.git";
}

# Requirements

    NixOS with flake support enabled.
    Bash environment variables should be set before you run your NixOS configuration.

# Contributing

If you have suggestions or improvements, feel free to submit an issue or pull request.
License

This flake is released under the MIT License. See the LICENSE file for more information.