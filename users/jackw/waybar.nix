# users/jackw/waybar.nix
# Waybar configuration with greyscale theme
{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 0;
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "custom/power" "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ 
          "memory"
          "cpu" 
          "bluetooth"
          "network"
          "pulseaudio"
          "battery"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = false;
          active-only = false;
          all-outputs = false;
          show-special = false;
        };

        "custom/power" = {
          format = "󰐥";
          tooltip = true;
          tooltip-format = "Power Menu";
          on-click = "wlogout -p layer-shell";
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 50;
          separate-outputs = true;
        };

        memory = {
          format = "󰍛 {percentage}%";
          tooltip-format = "RAM: {used:0.1f}GB / {total:0.1f}GB";
          on-click = "footclient -e htop -s PERCENT_MEM";
          interval = 5;
        };

        cpu = {
          format = "󰻠 {usage}%";
          tooltip-format = "CPU: {usage}%";
          on-click = "footclient -e htop -s PERCENT_CPU";
          interval = 5;
        };

        bluetooth = {
          format = "󰂯";
          format-connected = "󰂱 {device_alias}";
          format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
          format-disabled = "󰂲";
          format-off = "󰂲";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        network = {
          format-wifi = "󰖩 {signalStrength}%";
          format-ethernet = "󰈀";
          format-linked = "󰈀 (No IP)";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
          tooltip-format-ethernet = "{ifname}\n{ipaddr}/{cidr}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "networkmanager_dmenu";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "󰂰 {volume}%";
          format-muted = "󰖁";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰏲";
            car = "󰄋";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          tooltip-format = "{desc}: {volume}%";
          on-click = "pwvucontrol";
          scroll-step = 5;
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "{timeTo}\n{power}W";
          states = {
            warning = 30;
            critical = 15;
          };
        };

        clock = {
          format = "{:%I:%M %p}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#e0e0e0'><b>{}</b></span>";
              days = "<span color='#a0a0a0'>{}</span>";
              weeks = "<span color='#888888'>W{}</span>";
              weekdays = "<span color='#888888'><b>{}</b></span>";
              today = "<span color='#ffffff'><b><u>{}</u></b></span>";
            };
          };
        };
      };
    };

    style = ''
      /* Color Scheme - Edit these to change theme */
      @define-color bg-primary #1a1a1a;
      @define-color bg-secondary #2a2a2a;
      @define-color bg-tertiary #333333;
      @define-color text-primary #e0e0e0;
      @define-color text-secondary #a0a0a0;
      @define-color accent #888888;
      @define-color hover #3a3a3a;
      @define-color border-color #e0e0e0;
      @define-color warning #e5c07b;
      @define-color critical #e06c75;

      /* Base styling */
      * {
        font-family: "Miracode", "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: @bg-primary;
        color: @text-primary;
        border-radius: 10px;
        border: 2px solid @border-color;
      }

      /* Module containers */
      .modules-left,
      .modules-center,
      .modules-right {
        padding: 0 8px;
      }

      /* Workspaces */
      #workspaces {
        background: @bg-secondary;
        border-radius: 8px;
        padding: 2px 4px;
        margin: 4px 4px;
      }

      #workspaces button {
        color: @text-secondary;
        padding: 2px 10px;
        margin: 2px;
        border-radius: 6px;
        background: transparent;
        transition: all 0.2s ease;
        border: 1px solid transparent;
      }

      #workspaces button:hover {
        background: @hover;
        color: @text-primary;
      }

      #workspaces button.active {
        background: @bg-tertiary;
        color: @text-primary;
        border: 1px solid @border-color;
      }

      #workspaces button.urgent {
        background: @critical;
        color: @bg-primary;
      }

      /* Window title */
      #window {
        color: @text-secondary;
        padding: 0 12px;
      }

      /* Right-side modules */
      #memory,
      #cpu,
      #bluetooth,
      #network,
      #pulseaudio,
      #battery,
      #clock {
        background: @bg-secondary;
        padding: 4px 8px;
        margin: 4px 4px;
        border-radius: 8px;
        color: @text-primary;
        transition: all 0.2s ease;
      }

      /* Fix icon/text vertical alignment */
      #memory label,
      #cpu label,
      #bluetooth label,
      #network label,
      #pulseaudio label,
      #battery label,
      #clock label,
      #custom-power label {
        padding-top: 1px;
      }

      /* Hover effects for clickable items */
      #bluetooth:hover,
      #network:hover,
      #pulseaudio:hover,
      #custom-power:hover {
        background: @hover;
      }

      /* Power button */
      #custom-power {
        background: @bg-secondary;
        padding: 4px 8px;
        margin: 4px 4px;
        border-radius: 8px;
        color: @text-primary;
        transition: all 0.2s ease;
      }

      /* Battery states */
      #battery.warning {
        color: @warning;
      }

      #battery.critical {
        color: @critical;
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          background: @critical;
          color: @bg-primary;
        }
      }

      /* Clock */
      #clock {
        font-weight: bold;
      }

      /* Tooltip styling */
      tooltip {
        background: @bg-primary;
        border: 1px solid @bg-tertiary;
        border-radius: 8px;
      }

      tooltip label {
        color: @text-primary;
        padding: 8px;
      }
    '';
  };
}
