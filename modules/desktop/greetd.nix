# modules/desktop/greetd.nix
# greetd with tuigreet as the default login screen. Hosts that enable the
# Hayashi shell's greeter (programs.hayashi-shell.greeter.enable) replace it.
{ config, lib, pkgs, ... }:

let
  tuigreet = !config.programs.hayashi-shell.greeter.enable;
in
{
  services.greetd = {
    enable = true;
    settings.default_session = lib.mkIf tuigreet {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd start-hyprland";
      user = "greeter";
    };
  };

  environment.systemPackages = lib.mkIf tuigreet [ pkgs.tuigreet ];

  # tuigreet draws on the TTY directly.
  systemd.services.greetd.serviceConfig = lib.mkIf tuigreet {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
