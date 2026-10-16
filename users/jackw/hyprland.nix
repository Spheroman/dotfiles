# home/hyprland.nix
{ config, pkgs, lib, ... }:

let
  # Workspace keys: letters a-z and numbers 0-9
  keys = lib.strings.stringToCharacters "abcdefghijklmnopqrstuvwxyz0123456789";

  # Switch to workspace bindings
  workspaceBinds = lib.concatMapStrings (k: ''
    hl.bind(mod .. " + ${k}", hl.dsp.focus({ workspace = "name:${k}" }))
  '') keys;

  # Move window to workspace, then leave the submap
  moveToSingleBinds = lib.concatMapStrings (k: ''
      hl.bind("${k}", function()
        hl.dispatch(hl.dsp.window.move({ workspace = "name:${k}" }))
        hl.dispatch(hl.dsp.submap("reset"))
      end)
  '') keys;

  # Move window to workspace silently, staying in the submap
  moveToManyBinds = lib.concatMapStrings (k: ''
      hl.bind("${k}", hl.dsp.window.move({ workspace = "name:${k}", follow = false }))
  '') keys;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = { };
  };

  xdg.configFile."hypr/hyprland.lua".text = ''
    local mod = "SUPER"

    -- Monitors
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
    hl.monitor({ output = "DP-3", mode = "2560x1440@170", position = "0x0", scale = 1 })
    hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@99.61", position = "auto-center-left", scale = 1, transform = 1 })

    -- Environment
    hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
    hl.env("HYPRCURSOR_SIZE", "24")
    hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
    hl.env("XCURSOR_SIZE", "24")

    -- Startup applications
    hl.on("hyprland.start", function()
      hl.exec_cmd("foot --server")  -- foot daemon for fast terminal spawning
      hl.exec_cmd("waybar")
      hl.exec_cmd("mako")
      hl.exec_cmd("hyprpaper")
      hl.exec_cmd("wl-paste --watch cliphist store")  -- clipboard history
    end)

    hl.config({
      input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = { natural_scroll = true },  -- macOS-style scrolling
        sensitivity = 0,
        accel_profile = "flat",
      },

      general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
          active_border = "rgba(e0e0e0ff)",
          inactive_border = "rgba(e0e0e0aa)",
        },
        layout = "dwindle",
      },

      decoration = {
        rounding = 10,
        blur = {
          enabled = true,
          size = 8,
          passes = 2,
          new_optimizations = true,
          xray = true,
          ignore_opacity = true,
        },
        dim_inactive = false,
      },

      animations = { enabled = true },

      dwindle = {
        preserve_split = true,
      },
    })

    -- Animations
    hl.curve("easeInOutQuint", { type = "bezier", points = { { 0.83, 0 }, { 0.17, 1 } } })
    hl.curve("wind",           { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
    hl.curve("winIn",          { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
    hl.curve("winOut",         { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
    hl.curve("liner",          { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

    hl.animation({ leaf = "windows",     enabled = true, speed = 2,  bezier = "easeInOutQuint", style = "slide" })
    hl.animation({ leaf = "windowsIn",   enabled = true, speed = 2,  bezier = "easeInOutQuint", style = "slide" })
    hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2,  bezier = "easeInOutQuint", style = "slide" })
    hl.animation({ leaf = "windowsMove", enabled = true, speed = 2,  bezier = "easeInOutQuint", style = "slide" })
    hl.animation({ leaf = "border",      enabled = true, speed = 1,  bezier = "liner" })
    hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "loop" })
    hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "default" })
    hl.animation({ leaf = "workspaces",  enabled = true, speed = 2,  bezier = "easeInOutQuint" })

    -- Core bindings
    hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("footclient"))
    hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
    hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
    hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
    hl.bind(mod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))
    hl.bind(mod .. " + SHIFT + TAB", hl.dsp.workspace.move({ monitor = "+1" }))

    -- Screenshot with grimblast
    hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy area"))

    hl.bind(mod .. " + SHIFT + H", hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + SHIFT + J", hl.dsp.focus({ direction = "down" }))
    hl.bind(mod .. " + SHIFT + K", hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + SHIFT + L", hl.dsp.focus({ direction = "right" }))

    -- Enter submaps
    hl.bind(mod .. " + SHIFT + semicolon", hl.dsp.submap("movement"))
    hl.bind(mod .. " + SHIFT + M", hl.dsp.submap("movetosingle"))

    -- Switch to workspace
    ${workspaceBinds}
    -- Mouse bindings
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Media and brightness keys (from Hyprland's example config). `locked`
    -- keeps them working on the lock screen; no-ops on keyboards without them.
    hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
    hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
    hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
    hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

    -- Movement submap
    hl.define_submap("movement", function()
      hl.bind("h", hl.dsp.window.move({ direction = "left" }))
      hl.bind("j", hl.dsp.window.move({ direction = "down" }))
      hl.bind("k", hl.dsp.window.move({ direction = "up" }))
      hl.bind("l", hl.dsp.window.move({ direction = "right" }))
      hl.bind("SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
      hl.bind("SHIFT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
      hl.bind("SHIFT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
      hl.bind("SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
      hl.bind("f", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SHIFT + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
      hl.bind("m", hl.dsp.submap("movetomany"))
      hl.bind("q", hl.dsp.submap("reset"))
      hl.bind("escape", hl.dsp.submap("reset"))
      hl.bind("SUPER_L", hl.dsp.submap("reset"))
      hl.bind("catchall", hl.dsp.submap("movement"))
    end)

    -- Move to workspace, then exit
    hl.define_submap("movetosingle", function()
    ${moveToSingleBinds}
      hl.bind("escape", hl.dsp.submap("reset"))
      hl.bind("SUPER + SUPER_L", hl.dsp.submap("reset"))
      hl.bind("catchall", hl.dsp.submap("movetosingle"))
    end)

    -- Move to workspace silently, staying in the submap
    hl.define_submap("movetomany", function()
    ${moveToManyBinds}
      hl.bind("escape", hl.dsp.submap("reset"))
      hl.bind("SUPER + SUPER_L", hl.dsp.submap("reset"))
      hl.bind("catchall", hl.dsp.submap("movetomany"))
    end)
  '';

 
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
      splash = false;
      wallpaper = [
        {
          monitor = "";  # Empty monitor = fallback for all monitors
          path = "~/Pictures/wallpaper.jpg";
        }
      ];
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
