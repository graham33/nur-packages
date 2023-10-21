# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

let
  myPackages = pkgs.lib.makeScope pkgs.newScope (self: with self; {

    ha-dyson = callPackage ./pkgs/ha-dyson { };
    ha-dyson-cloud = callPackage ./pkgs/ha-dyson-cloud { };
    ha-hildebrandglow-dcc = callPackage ./pkgs/ha-hildebrandglow-dcc { };

    hass-smartbox = callPackage ./pkgs/hass-smartbox {};
    hassio-ecoflow = callPackage ./pkgs/hassio-ecoflow { };
    heatmiser-for-home-assistant = callPackage ./pkgs/heatmiser-for-home-assistant { };

    home-assistant = (pkgs.home-assistant.override {
      # TODO: fix upstream
      extraPackages = ps: [ps.ifaddr];
      packageOverrides = homeAssistantPackageOverrides;
    }).overrideAttrs (o: {
      # tests take a really long time
      doInstallCheck = false;
    });

    home-assistant-miele = callPackage ./pkgs/home-assistant-miele { };

    homeAssistantPackageOverrides = pySelf: pySuper: rec {
      async-property = pySelf.callPackage ./pkgs/async-property { };
      buildHomeAssistantCustomComponent = callPackage pkgs/build-support/build-home-assistant-custom-component {};

      # authcaptureproxy = pySelf.callPackage ./pkgs/authcaptureproxy { };
      # fiblary3 = pySelf.callPackage ./pkgs/fiblary3 { };
      garminconnect = pySelf.callPackage ./pkgs/garminconnect { };
      homeassistant = (pySelf.toPythonModule home-assistant);
      homeassistant-stubs = pySelf.callPackage ./pkgs/homeassistant-stubs { };
      libdyson = pySelf.callPackage ./pkgs/libdyson { };
      monkeytype = pySelf.callPackage ./pkgs/monkeytype { };
      neohubapi = pySelf.callPackage ./pkgs/neohubapi { };
      pylint-per-file-ignores = pySelf.callPackage ./pkgs/pylint-per-file-ignores { };
      pymiele = pySelf.callPackage ./pkgs/pymiele { };
      pynut2 = pySelf.callPackage ./pkgs/pynut2 { };
      pytest-homeassistant-custom-component = pySelf.callPackage ./pkgs/pytest-homeassistant-custom-component { };
      pytest-picked = pySelf.callPackage ./pkgs/pytest-picked { };
      python-engineio_3 = pySelf.callPackage ./pkgs/python-engineio/3.nix { };
      python-socketio_4 = pySelf.callPackage ./pkgs/python-socketio/4.nix { };
      ring_doorbell = pySelf.callPackage ./pkgs/ring_doorbell { };
      smartbox = pySelf.callPackage ./pkgs/smartbox { };
      # typer = pySelf.callPackage ./pkgs/typer { };

      # These use a conflicting version of python-socketio
      aioambient = null;
      simplisafe-python = null;
    };

    libedgetpu = callPackage ./pkgs/libedgetpu { };

    miele-custom-component = callPackage ./pkgs/miele-custom-component { };

    octopus-energy = callPackage ./pkgs/octopus-energy { };

    python3 = let
      packageOverrides = pySelf: pySuper: rec {
        json_exporter = pySelf.callPackage ./pkgs/json_exporter { };
      };
    in
      pkgs.python3.override { inherit packageOverrides; self = python3; };
    python3Packages = python3.pkgs;

    solis-sensor = callPackage ./pkgs/solis-sensor { };
    tesla-custom-component = callPackage ./pkgs/tesla-custom-component { };
  });

  # pkg_21-11 = pkg: if (builtins.match "^21\.11.*" pkgs.lib.version != null) then pkg else null;
in rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # for CI
  inherit (pkgs) nix-build-uncached;

  inherit (myPackages)
    ha-dyson
    ha-dyson-cloud
    ha-hildebrandglow-dcc
    hass-smartbox
    hassio-ecoflow
    heatmiser-for-home-assistant
    home-assistant
    home-assistant-miele
    homeAssistantPackageOverrides
    libedgetpu
    miele-custom-component
    octopus-energy
    solis-sensor
    tesla-custom-component
  ;

  python3Packages = {
    inherit (myPackages.python3Packages) json_exporter;
  };

  inherit (home-assistant.python.pkgs)
    async-property
    homeassistant
    homeassistant-stubs
    neohubapi
    pylint-per-file-ignores
    pytest-homeassistant-custom-component
    smartbox
  ;
}
