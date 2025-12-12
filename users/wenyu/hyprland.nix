# home/hyprland.nix
{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration
      monitor = [ 
        ",preferred,auto,1"
        "DP-3, 2560x1440@170, 0x0, 1"
        "HDMI-A-1, 1920x1080@99.61, auto-center-left, 1, transform, 1"
      ];

      # Startup applications
      exec-once = [
        "foot --server &"  # Start foot daemon
        "ashell &"

        "[workspace z silent] zen"
        "mako"
        "hyprpaper"
        "wl-paste --watch cliphist store"  # Clipboard history
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;  # macOS-style scrolling
        };
        sensitivity = 0;
        accel_profile = "flat";
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          new_optimizations = true;
          xray = true;
          ignore_opacity = true;
        };
        dim_inactive = false;
      };

      # Animations
      animations = {
        enabled = true;
        bezier = [
          "easeInOutQuint, 0.83, 0, 0.17, 1"
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 2, easeInOutQuint, slide"
          "windowsIn, 1, 2, easeInOutQuint, slide"
          "windowsOut, 1, 2, easeInOutQuint, slide"
          "windowsMove, 1, 2, easeInOutQuint, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 2, easeInOutQuint"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Main bindings
      "$mod" = "SUPER";
      
      bind = [
        # Core bindings
        "$mod, RETURN, exec, footclient"
        "$mod, SPACE, exec, rofi -show drun"
        "$mod SHIFT, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, TAB, workspace, previous"
        "$mod SHIFT, TAB, movecurrentworkspacetomonitor, +1"

        "$mod SHIFT, H, movefocus, l"
        "$mod SHIFT, J, movefocus, d"
        "$mod SHIFT, K, movefocus, u"
        "$mod SHIFT, L, movefocus, r"

        # Enter movement submode
        "$mod SHIFT, semicolon, submap, movement"
        "$mod SHIFT, M, submap, movetosingle"

        # Workspace switching - letters
        "$mod, A, workspace, name:a"
        "$mod, B, workspace, name:b"
        "$mod, C, workspace, name:c"
        "$mod, D, workspace, name:d"
        "$mod, E, workspace, name:e"
        "$mod, F, workspace, name:f"
        "$mod, G, workspace, name:g"
        "$mod, H, workspace, name:h"
        "$mod, I, workspace, name:i"
        "$mod, J, workspace, name:j"
        "$mod, K, workspace, name:k"
        "$mod, L, workspace, name:l"
        "$mod, M, workspace, name:m"
        "$mod, N, workspace, name:n"
        "$mod, O, workspace, name:o"
        "$mod, P, workspace, name:p"
        "$mod, Q, workspace, name:q"
        "$mod, R, workspace, name:r"
        "$mod, S, workspace, name:s"
        "$mod, T, workspace, name:t"
        "$mod, U, workspace, name:u"
        "$mod, V, workspace, name:v"
        "$mod, W, workspace, name:w"
        "$mod, X, workspace, name:x"
        "$mod, Y, workspace, name:y"
        "$mod, Z, workspace, name:z"
        
        # Workspace switching - numbers
        "$mod, 1, workspace, name:1"
        "$mod, 2, workspace, name:2"
        "$mod, 3, workspace, name:3"
        "$mod, 4, workspace, name:4"
        "$mod, 5, workspace, name:5"
        "$mod, 6, workspace, name:6"
        "$mod, 7, workspace, name:7"
        "$mod, 8, workspace, name:8"
        "$mod, 9, workspace, name:9"
        "$mod, 0, workspace, name:0"
      ];

      # Movement submode
      submap = [
        ''movement
bind = ,h,movewindow,l
bind = ,j,movewindow,d
bind = ,k,movewindow,u
bind = ,l,movewindow,r
bind = SHIFT, h,resizeactive,-50 0
bind = SHIFT, j,resizeactive,0 50
bind = SHIFT, k,resizeactive,0 -50
bind = SHIFT, l,resizeactive,50 0
bind = ,f,togglefloating,
bind = SHIFT, f,fullscreen,0
bind = ,m,submap,movetomany
bind = ,q,submap,reset
bind = ,escape,submap,reset
bind = ,SUPER,submap,reset
bind = , catchall, submap, movement
submap = reset
''
''movetosingle
bind = , a, movetoworkspace, name:a
bind = , a, submap, reset
bind = , b, movetoworkspace, name:b
bind = , b, submap, reset
bind = , c, movetoworkspace, name:c
bind = , c, submap, reset
bind = , d, movetoworkspace, name:d
bind = , d, submap, reset
bind = , e, movetoworkspace, name:e
bind = , e, submap, reset
bind = , f, movetoworkspace, name:f
bind = , f, submap, reset
bind = , g, movetoworkspace, name:g
bind = , g, submap, reset
bind = , h, movetoworkspace, name:h
bind = , h, submap, reset
bind = , i, movetoworkspace, name:i
bind = , i, submap, reset
bind = , j, movetoworkspace, name:j
bind = , j, submap, reset
bind = , k, movetoworkspace, name:k
bind = , k, submap, reset
bind = , l, movetoworkspace, name:l
bind = , l, submap, reset
bind = , m, movetoworkspace, name:m
bind = , m, submap, reset
bind = , n, movetoworkspace, name:n
bind = , n, submap, reset
bind = , o, movetoworkspace, name:o
bind = , o, submap, reset
bind = , p, movetoworkspace, name:p
bind = , p, submap, reset
bind = , q, movetoworkspace, name:q
bind = , q, submap, reset
bind = , r, movetoworkspace, name:r
bind = , r, submap, reset
bind = , s, movetoworkspace, name:s
bind = , s, submap, reset
bind = , t, movetoworkspace, name:t
bind = , t, submap, reset
bind = , u, movetoworkspace, name:u
bind = , u, submap, reset
bind = , v, movetoworkspace, name:v
bind = , v, submap, reset
bind = , w, movetoworkspace, name:w
bind = , w, submap, reset
bind = , x, movetoworkspace, name:x
bind = , x, submap, reset
bind = , y, movetoworkspace, name:y
bind = , y, submap, reset
bind = , z, movetoworkspace, name:z
bind = , z, submap, reset
bind = , 1, movetoworkspace, name:1
bind = , 1, submap, reset
bind = , 2, movetoworkspace, name:2
bind = , 2, submap, reset
bind = , 3, movetoworkspace, name:3
bind = , 3, submap, reset
bind = , 4, movetoworkspace, name:4
bind = , 4, submap, reset
bind = , 5, movetoworkspace, name:5
bind = , 5, submap, reset
bind = , 6, movetoworkspace, name:6
bind = , 6, submap, reset
bind = , 7, movetoworkspace, name:7
bind = , 7, submap, reset
bind = , 8, movetoworkspace, name:8
bind = , 8, submap, reset
bind = , 9, movetoworkspace, name:9
bind = , 9, submap, reset
bind = , 0, movetoworkspace, name:0
bind = , 0, submap, reset

# Exit movetoworkspace submode
bind = , escape, submap, reset
bind = SUPER, SUPER_L, submap, reset

bind = , catchall, submap, movetosingle

submap = reset
''
''movetomany
bind = , a, movetoworkspacesilent, name:a
bind = , b, movetoworkspacesilent, name:b
bind = , c, movetoworkspacesilent, name:c
bind = , d, movetoworkspacesilent, name:d
bind = , e, movetoworkspacesilent, name:e
bind = , f, movetoworkspacesilent, name:f
bind = , g, movetoworkspacesilent, name:g
bind = , h, movetoworkspacesilent, name:h
bind = , i, movetoworkspacesilent, name:i
bind = , j, movetoworkspacesilent, name:j
bind = , k, movetoworkspacesilent, name:k
bind = , l, movetoworkspacesilent, name:l
bind = , m, movetoworkspacesilent, name:m
bind = , n, movetoworkspacesilent, name:n
bind = , o, movetoworkspacesilent, name:o
bind = , p, movetoworkspacesilent, name:p
bind = , q, movetoworkspacesilent, name:q
bind = , r, movetoworkspacesilent, name:r
bind = , s, movetoworkspacesilent, name:s
bind = , t, movetoworkspacesilent, name:t
bind = , u, movetoworkspacesilent, name:u
bind = , v, movetoworkspacesilent, name:v
bind = , w, movetoworkspacesilent, name:w
bind = , x, movetoworkspacesilent, name:x
bind = , y, movetoworkspacesilent, name:y
bind = , z, movetoworkspacesilent, name:z
bind = , 1, movetoworkspacesilent, name:1
bind = , 2, movetoworkspacesilent, name:2
bind = , 3, movetoworkspacesilent, name:3
bind = , 4, movetoworkspacesilent, name:4
bind = , 5, movetoworkspacesilent, name:5
bind = , 6, movetoworkspacesilent, name:6
bind = , 7, movetoworkspacesilent, name:7
bind = , 8, movetoworkspacesilent, name:8
bind = , 9, movetoworkspacesilent, name:9
bind = , 0, movetoworkspacesilent, name:0

bind = , escape, submap, reset
bind = SUPER, SUPER_L, submap, reset

bind = , catchall, submap, movetomany

submap = reset
''
      ];
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

 
  # Rofi configuration
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "Arc-Dark";
    terminal = "${pkgs.foot}/bin/footclient";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = false;
      display-drun = "  Apps";
      display-run = "  Run";
      display-window = " 﩯 Window";
    };
  };

  # Mako notification daemon
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1a1b26";
      border-color = "#33ccff";
      border-radius = 10;
      border-size = 2;
      text-color = "#ffffff";
      width = 400;
      height = 150;
      margin = "20";
      padding = "15";
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 11";
    };
    extraConfig = ''
      [urgency=high]
      border-color=#f7768e
      default-timeout=0
    '';
  };

  # Hyprpaper wallpaper daemon
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/Pictures/wallpaper.png" ];
      wallpaper = [ ",~/Pictures/wallpaper.png" ];
      splash = false;
    };
  };

  # Additional packages for the workflow
  home.packages = with pkgs; [
    cliphist  # Clipboard manager
    wl-clipboard
    pavucontrol  # Audio control
    networkmanagerapplet  # Network management
    blueman  # Bluetooth management
    jetbrains-mono  # Font for waybar
    font-awesome  # Icons
    nerd-fonts.jetbrains-mono
    nemo
    foot  # Terminal emulator
  ];

  # Hyprlock for screen locking (optional)
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [{
        path = "~/Pictures/wallpaper.jpg";
        blur_passes = 3;
        blur_size = 8;
      }];

      input-field = [{
        size = "300, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.5)";
        font_color = "rgb(255, 255, 255)";
        fade_on_empty = false;
        placeholder_text = "<i><span foreground=\"##ffffff\">Password...</span></i>";
        hide_input = false;
        position = "0, -200";
        halign = "center";
        valign = "center";
      }];

      label = [
        {
          text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 22;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 95;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hypridle for idle management
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;  # 5 min
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;  # 10 min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;  # 15 min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;  # 30 min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
