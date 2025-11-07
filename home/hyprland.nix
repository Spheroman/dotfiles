# home/hyprland.nix
{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration
      monitor = ",preferred,auto,1";

      # Autostart
      exec-once = [
        "waybar"
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
        accel_profile = "adaptive";
      };

      # General settings
      general = {
        gaps_in = 10;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        resize_on_border = true;
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
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
        dim_inactive = false;
      };

      # Animations
      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      # Dwindle layout (tiling)
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;  # Always split to the right/bottom
        no_gaps_when_only = false;
      };

      # Master layout (alternative)
      master = {
        new_status = "master";
      };

      # Misc settings
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        vrr = 1;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        enable_swallow = true;
        swallow_regex = "^(kitty|Alacritty)$";
      };

      # Window rules
      windowrulev2 = [
        # Float specific windows
        "float,class:^(pavucontrol)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(blueman-manager)$"
        "float,title:^(Picture-in-Picture)$"

        # Pin picture-in-picture
        "pin,title:^(Picture-in-Picture)$"

        # Opacity rules
        "opacity 0.95 0.85,class:^(kitty)$"
        "opacity 0.95 0.85,class:^(Alacritty)$"

        # Workspace assignments (examples)
        "workspace 2,class:^(firefox)$"
        "workspace 2,class:^(zen-alpha)$"
        "workspace 3,class:^(Code)$"
        "workspace 4,class:^(discord)$"
      ];

      # Keybindings - AeroSpace style with SUPER instead of ALT
      "$mod" = "SUPER";

      bind = [
        # Launch applications
        "$mod, Return, exec, kitty"
        "$mod, SPACE, exec, rofi -show drun"

        # Window management
        "$mod, Q, killactive"
        "$mod SHIFT, M, exit"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"  # dwindle
        "$mod, F, fullscreen"

        # Layout switching
        "$mod, SLASH, togglesplit"  # equivalent to layout toggle
        "$mod, COMMA, pseudo"  # placeholder for accordion-like behavior

        # Focus movement (VIM-style: H J K L)
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        # Move windows (VIM-style with SHIFT)
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        # Resize windows
        "$mod, MINUS, splitratio, -0.1"
        "$mod, EQUAL, splitratio, +0.1"

        # Workspace switching (1-9 + letters)
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Letter workspaces (A-Z)
        "$mod, A, workspace, 10"
        "$mod, B, workspace, 11"
        "$mod, C, workspace, 12"
        "$mod, D, workspace, 13"
        "$mod, E, workspace, 14"
        "$mod, G, workspace, 15"
        "$mod, I, workspace, 16"
        "$mod, M, workspace, 17"
        "$mod, N, workspace, 18"
        "$mod, O, workspace, 19"
        "$mod, R, workspace, 20"
        "$mod, S, workspace, 21"
        "$mod, T, workspace, 22"
        "$mod, U, workspace, 23"
        "$mod, W, workspace, 24"
        "$mod, X, workspace, 25"
        "$mod, Y, workspace, 26"
        "$mod, Z, workspace, 27"

        # Move window to workspace (1-9)
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Move window to letter workspaces
        "$mod SHIFT, A, movetoworkspace, 10"
        "$mod SHIFT, B, movetoworkspace, 11"
        "$mod SHIFT, C, movetoworkspace, 12"
        "$mod SHIFT, D, movetoworkspace, 13"
        "$mod SHIFT, E, movetoworkspace, 14"
        "$mod SHIFT, G, movetoworkspace, 15"
        "$mod SHIFT, I, movetoworkspace, 16"
        "$mod SHIFT, N, movetoworkspace, 18"
        "$mod SHIFT, O, movetoworkspace, 19"
        "$mod SHIFT, R, movetoworkspace, 20"
        "$mod SHIFT, S, movetoworkspace, 21"
        "$mod SHIFT, T, movetoworkspace, 22"
        "$mod SHIFT, U, movetoworkspace, 23"
        "$mod SHIFT, W, movetoworkspace, 24"
        "$mod SHIFT, X, movetoworkspace, 25"
        "$mod SHIFT, Y, movetoworkspace, 26"
        "$mod SHIFT, Z, movetoworkspace, 27"

        # Workspace back-and-forth (like alt-tab in AeroSpace)
        "$mod, TAB, workspace, previous"

        # Move workspace to next monitor
        "$mod SHIFT, TAB, movecurrentworkspacetomonitor, +1"

        # Screenshot utilities
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"
        "$mod, Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png"

        # Service mode (SUPER + SHIFT + SEMICOLON)
        "$mod SHIFT, SEMICOLON, submap, service"

        # Clipboard history
        "$mod, period, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      ];

      # Service submap (like AeroSpace's service mode)
      submap = [
        "service"
      ];

    };

    # Extra config for service submap
    extraConfig = ''
      # Service mode bindings
      submap=service
      bind=,escape,submap,reset
      bind=,R,exec,hyprctl reload
      bind=,R,submap,reset
      bind=,F,togglefloating
      bind=,F,submap,reset
      bind=,backspace,exec,hyprctl clients | grep "class:" | awk '{print $2}' | xargs -I{} hyprctl dispatch closewindow address:{}
      bind=,backspace,submap,reset

      # Join windows (grouping)
      bind=SHIFT,H,moveintogroup,l
      bind=SHIFT,H,submap,reset
      bind=SHIFT,J,moveintogroup,d
      bind=SHIFT,J,submap,reset
      bind=SHIFT,K,moveintogroup,u
      bind=SHIFT,K,submap,reset
      bind=SHIFT,L,moveintogroup,r
      bind=SHIFT,L,submap,reset

      submap=reset
    '';
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.9);
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #ffffff;
        border-bottom: 3px solid transparent;
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: inset 0 -3px #ffffff;
      }

      #workspaces button.active {
        background-color: rgba(255, 255, 255, 0.1);
        border-bottom: 3px solid #00ff99;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #mpd {
        padding: 0 10px;
        margin: 0 4px;
        color: #ffffff;
      }

      #window {
        margin: 0 10px;
      }

      #clock {
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
      }

      #battery {
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
      }

      #battery.charging, #battery.plugged {
        color: #00ff99;
      }

      #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #cpu {
        background-color: rgba(52, 152, 219, 0.3);
        border-radius: 10px;
      }

      #memory {
        background-color: rgba(155, 89, 182, 0.3);
        border-radius: 10px;
      }

      #network {
        background-color: rgba(46, 204, 113, 0.3);
        border-radius: 10px;
      }

      #network.disconnected {
        background-color: rgba(231, 76, 60, 0.3);
      }

      #pulseaudio {
        background-color: rgba(241, 196, 15, 0.3);
        border-radius: 10px;
      }

      #pulseaudio.muted {
        background-color: rgba(231, 76, 60, 0.3);
        color: #ffffff;
      }

      #temperature {
        background-color: rgba(230, 126, 34, 0.3);
        border-radius: 10px;
      }

      #temperature.critical {
        background-color: #eb4d4b;
      }

      #tray {
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
      }

      #idle_inhibitor {
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
      }

      #idle_inhibitor.activated {
        background-color: rgba(236, 239, 244, 0.3);
        color: #000000;
      }
    '';

    settings = [{
      layer = "top";
      position = "top";
      height = 35;
      spacing = 4;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "tray"
      ];

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
      };

      "hyprland/window" = {
        format = "{}";
        max-length = 50;
        separate-outputs = true;
      };

      tray = {
        spacing = 10;
      };

      clock = {
        format = "{:%a %b %d  %I:%M %p}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = " {usage}%";
        tooltip = false;
        interval = 2;
      };

      memory = {
        format = " {}%";
        interval = 2;
      };

      temperature = {
        critical-threshold = 80;
        format = "{icon} {temperatureC}°C";
        format-icons = ["" "" ""];
        interval = 2;
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = ["" "" "" "" ""];
      };

      network = {
        format-wifi = " {essid}";
        format-ethernet = " {ipaddr}";
        format-linked = " {ifname} (No IP)";
        format-disconnected = "⚠ Disconnected";
        tooltip-format = "{ifname} via {gwaddr}";
        tooltip-format-wifi = " {essid} ({signalStrength}%)";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "{icon} {volume}%";
        format-bluetooth-muted = " {icon}";
        format-muted = " {volume}%";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };
    }];
  };

  # Rofi configuration
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "Arc-Dark";
    terminal = "${pkgs.kitty}/bin/kitty";
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
    backgroundColor = "#1a1b26";
    borderColor = "#33ccff";
    borderRadius = 10;
    borderSize = 2;
    textColor = "#ffffff";
    width = 400;
    height = 150;
    margin = "20";
    padding = "15";
    defaultTimeout = 5000;
    font = "JetBrainsMono Nerd Font 11";
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
    pavucontrol  # Audio control
    networkmanagerapplet  # Network management
    blueman  # Bluetooth management
    jetbrains-mono  # Font for waybar
    font-awesome  # Icons
    nerd-fonts.jetbrains-mono
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
