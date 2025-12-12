# home/hyprland.nix
{ config, pkgs, lib, ... }:

let
  # Generate workspace bindings for letters a-z and numbers 0-9
  letters = lib.strings.stringToCharacters "abcdefghijklmnopqrstuvwxyz";
  numbers = lib.strings.stringToCharacters "0123456789";
  
  # Switch to workspace bindings
  workspaceBinds = 
    (map (ws: "$mod, ${lib.strings.toUpper ws}, workspace, name:${ws}") letters) ++
    (map (n: "$mod, ${n}, workspace, name:${n}") numbers);
  
  # Generate movetoworkspace submodes content
  moveToSingleBinds = lib.concatStringsSep "\n" (
    (map (ws: "bind = , ${ws}, movetoworkspace, name:${ws}\nbind = , ${ws}, submap, reset") letters) ++
    (map (n: "bind = , ${n}, movetoworkspace, name:${n}\nbind = , ${n}, submap, reset") numbers)
  );
  
  moveToManyBinds = lib.concatStringsSep "\n" (
    (map (ws: "bind = , ${ws}, movetoworkspacesilent, name:${ws}") letters) ++
    (map (n: "bind = , ${n}, movetoworkspacesilent, name:${n}") numbers)
  );
in
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
        "foot --server &"  # Start foot daemon for fast terminal spawning
        "waybar &"
        # Start emacs daemon if not running
        "emacsclient -c -a 'emacs --daemon' || true"
        # Start on workspace e with emacs
        "[workspace e silent] emacsclient -c"
        "[workspace z silent] zen"
        "mako"
        "hyprpaper"
        "wl-paste --watch cliphist store"  # Clipboard history
      ];

      # Workspace rules - keep emacs in workspace e
      windowrulev2 = [
        "workspace name:e,class:^(Emacs)$"
        # Idle inhibitors - prevent screen lock during fullscreen/video
        "idleinhibit fullscreen, class:.*"
        "idleinhibit focus, class:^(mpv|vlc|firefox|zen)$"
      ];

      # Workspace event handlers to reopen emacs
      exec = [
        # This watches for workspace changes and reopens emacs on workspace e if needed
        "bash -c 'socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do if echo \"$line\" | grep -q \"workspace>>e\"; then if ! hyprctl clients | grep -q \"class: Emacs\"; then emacsclient -c & fi; fi; done'"
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
        "col.active_border" = "rgba(e0e0e0ff)";
        "col.inactive_border" = "rgba(e0e0e0aa)";
        layout = "dwindle";
      };

      env = [
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "XCURSOR_SIZE,24"
      ];

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

        # Screenshot with grimblast
        "$mod SHIFT, S, exec, grimblast copy area"

        "$mod SHIFT, H, movefocus, l"
        "$mod SHIFT, J, movefocus, d"
        "$mod SHIFT, K, movefocus, u"
        "$mod SHIFT, L, movefocus, r"

        # Enter movement submode
        "$mod SHIFT, semicolon, submap, movement"
        "$mod SHIFT, M, submap, movetosingle"
      ] ++ workspaceBinds;

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
${moveToSingleBinds}

# Exit movetoworkspace submode
bind = , escape, submap, reset
bind = SUPER, SUPER_L, submap, reset

bind = , catchall, submap, movetosingle

submap = reset
''
        ''movetomany
${moveToManyBinds}

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
      preload = [ "~/Pictures/wallpaper.jpg" ];
      wallpaper = [ ",~/Pictures/wallpaper.jpg" ];
      splash = false;
    };
  };

  # Additional packages for the workflow
  home.packages = with pkgs; [
    cliphist  # Clipboard manager
    wl-clipboard
    pavucontrol  # Audio control (full)
    pwvucontrol  # Lightweight PipeWire volume control
    networkmanagerapplet  # Network management
    networkmanager_dmenu  # Rofi-style network selector
    blueman  # Bluetooth management
    jetbrains-mono  # Font for waybar
    font-awesome  # Icons
    nerd-fonts.jetbrains-mono
    nemo
    wlogout  # Power menu
    bibata-cursors
    hyprcursor
    grimblast  # Screenshot utility
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
