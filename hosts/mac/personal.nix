# hosts/mac/personal.nix — computer-3, the personal Apple Silicon Mac.
#
# Layers the personal-only apps on top of hosts/mac/common.nix. Homebrew's
# tap/brew/cask options are lists, so everything here is appended to the
# shared set rather than replacing it.
#
# `onActivation.cleanup` stays at the common default of "zap": on a machine
# where nothing gets installed out-of-band, having brew reap anything not
# declared here is the point.
{ username, ... }:

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
      # menu bar — runs the lid-awake toggle below
      "swiftbar"
    ];
  };

  # Menu-bar toggle for staying awake with the lid closed.
  #
  # `pmset disablesleep` is the only thing that survives a lid close without
  # an external display, and it needs root, so sudoers allows exactly the two
  # toggle commands without a password. SwiftBar runs the plugin below; the
  # 10s in its filename is the refresh interval, so the icon also catches
  # changes made from a terminal.

  security.sudo.extraConfig = ''
    ${username} ALL=(root) NOPASSWD: /usr/bin/pmset -a disablesleep 0, /usr/bin/pmset -a disablesleep 1
  '';

  system.defaults.CustomUserPreferences."com.ameba.SwiftBar" = {
    PluginDirectory = "/Users/${username}/.config/swiftbar";
  };

  home-manager.users.${username}.home.file.".config/swiftbar/lid-awake.10s.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      # <swiftbar.hideAbout>true</swiftbar.hideAbout>
      # <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
      # <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
      # <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
      # <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
      on=$(/usr/bin/pmset -g | /usr/bin/awk '/SleepDisabled/ { print $2 }')
      if [ "$1" = toggle ]; then
        exec /usr/bin/sudo -n /usr/bin/pmset -a disablesleep $((1 - on))
      fi
      if [ "$on" = 1 ]; then
        echo ":cup.and.saucer.fill:"
        echo "---"
        echo "Awake with lid closed: On"
        echo "Turn off | bash='$0' param1=toggle terminal=false refresh=true"
      else
        echo ":moon.zzz:"
        echo "---"
        echo "Awake with lid closed: Off"
        echo "Turn on | bash='$0' param1=toggle terminal=false refresh=true"
      fi
    '';
  };

  launchd.user.agents.swiftbar.serviceConfig = {
    ProgramArguments = [ "/Applications/SwiftBar.app/Contents/MacOS/SwiftBar" ];
    RunAtLoad = true;
    ProcessType = "Interactive";
  };
}
