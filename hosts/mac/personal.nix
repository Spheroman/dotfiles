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
      # messaging apps
      "signal"
      # embroidery — Inkscape extension; inkscape itself comes from common.nix
      "inkstitch"
    ];
  };

  # Stay awake with the lid closed, but only on AC power.
  #
  # `pmset disablesleep` is one system-wide flag (pmset's -c/-b are ignored
  # for it), so this daemon polls the power source and flips it to match.
  # Unplugging with the lid already shut would otherwise leave the Mac awake
  # in a bag, so that transition also forces an immediate sleep.
  launchd.daemons.lid-awake-on-ac = {
    script = ''
      if /usr/bin/pmset -g ps | /usr/bin/grep -q "AC Power"; then want=1; else want=0; fi
      have=$(/usr/bin/pmset -g | /usr/bin/awk '/SleepDisabled/ { print $2 }')
      [ "$want" = "$have" ] && exit 0
      /usr/bin/pmset -a disablesleep "$want"
      if [ "$want" = 0 ] && /usr/sbin/ioreg -r -k AppleClamshellState -d 4 \
          | /usr/bin/grep -q '"AppleClamshellState" = Yes'; then
        /usr/bin/pmset sleepnow
      fi
    '';
    serviceConfig = {
      RunAtLoad = true;
      StartInterval = 10;
    };
  };
}
