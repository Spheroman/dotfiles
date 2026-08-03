# hosts/mac/personal.nix — computer-3, the personal Apple Silicon Mac.
#
# Layers the personal-only apps on top of hosts/mac/common.nix. Homebrew's
# tap/brew/cask options are lists, so everything here is appended to the
# shared set rather than replacing it.
#
# `onActivation.cleanup` stays at the common default of "zap": on a machine
# where nothing gets installed out-of-band, having brew reap anything not
# declared here is the point.
{ ... }:

{
  homebrew = {
    taps = [
      "kegworks-app/kegworks" # provides the kegworks cask
      "sikarugir-app/sikarugir"
    ];
    casks = [
      # jetbrains-toolbox and vmware-fusion are personal-only: their licenses
      # distinguish personal from commercial use, so they stay off the work Mac.
      "jetbrains-toolbox"
      "vmware-fusion"
      # gaming / compatibility layers
      "kegworks-app/kegworks/kegworks"
      "playcover-community"
      "steam"
      "minecraft"
    ];
  };
}
