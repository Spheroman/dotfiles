# home/programs/default.nix
{ config, pkgs, ... }:

{
  # Zen Browser
  programs.zen-browser.enable = true;

  # Git
  programs.git = {
    enable = true;
    userName = "Wang Wenyu";
    userEmail = "wen.wang2001@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # Alacritty terminal
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };



  # VSCode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      visualstudioexptteam.vscodeintellicode
      njpwerner.autodocstring
      ms-toolsai.jupyter
      ms-python.python
      wholroyd.jinja
      batisteo.vscode-django
      ms-python.pylint
      ms-python.debugpy
      ms-python.black-formatter
      ms-python.vscode-pylance
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
