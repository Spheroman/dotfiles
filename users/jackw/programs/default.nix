# home/programs/default.nix
{ config, pkgs, ... }:

{

  imports = [
    ./foot.nix
  ];

  # Zen Browser
  programs.zen-browser.enable = true;

  # Git, starship, direnv and fzf are shared with the Macs: ../git.nix and
  # ../shell.nix.

  # VSCode
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      visualstudioexptteam.vscodeintellicode
      donjayamanne.githistory
      alefragnani.project-manager
      eamodio.gitlens
      codezombiech.gitignore
      yy0931.vscode-sqlite3-editor
      ms-vscode-remote.remote-ssh-edit
      leonardssh.vscord
    ];
  };

  # Solaar mouse configuration
  xdg.configFile."solaar/rules.yaml".source = (pkgs.formats.yaml { }).generate "rules" [
    {
      Rule = [
        { Test = [ "thumb_wheel_up" 20]; }
        { KeyPress = [ ["Control_L" "Tab"] "click" ]; }
      ];
    }
    {
      Rule = [
        { Test = [ "thumb_wheel_down" 20]; }
        { KeyPress = [ ["Control_L" "Shift_L" "Tab"] "click" ]; }
      ];
    }
  ];
}
