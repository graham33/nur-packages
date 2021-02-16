# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  enroot = pkgs.callPackage ./pkgs/enroot { };
  fiblary3 = pkgs.python3Packages.callPackage ./pkgs/fiblary3 { };
  garminconnect = pkgs.python3Packages.callPackage ./pkgs/garminconnect { };
  hass-smartbox = pkgs.python3Packages.callPackage ./pkgs/hass-smartbox { };
  libpurecool = pkgs.python3Packages.callPackage ./pkgs/libpurecool { };
  # TODO: use overlay to override
  python-engineio_3 = pkgs.python3Packages.callPackage ./pkgs/python-engineio/3.nix { };
  python-socketio_4 = pkgs.python3Packages.callPackage ./pkgs/python-socketio/4.nix { inherit python-engineio_3; };
  ring_doorbell = pkgs.python3Packages.callPackage ./pkgs/ring_doorbell { };
  smartbox = pkgs.python3Packages.callPackage ./pkgs/smartbox { python-socketio = python-socketio_4; };
  teslajsonpy = pkgs.python3Packages.callPackage ./pkgs/teslajsonpy { };
}
