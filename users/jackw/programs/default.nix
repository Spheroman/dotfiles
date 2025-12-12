# home/programs/default.nix
{ config, pkgs, ... }:

{

  imports = [
    ./foot.nix
  ];

  # Zen Browser
  programs.zen-browser.enable = true;

  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Jack Wen";
      user.email = "jackwen04@gmail.com";
      url."git@github.com:".insteadOf = "https://github.com/";
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

  # Direnv for per-project environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # Fzf for fuzzy finding
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
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
    profiles.default.extensions = with pkgs.vscode-extensions; [
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
