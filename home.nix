{
  lib,
  pkgs,
  ...
}:
{
  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "rose-pine";
      icon-theme = "rose-pine";
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  programs.git = {
    enable = true;
    includes = [
      {
        contents = {
          init.defaultBranch = "main";
          core.editor = "nvim";
        };
      }
    ];
    userName = "Matt Muldowney";
    userEmail = "matt.muldowney@gmail.com";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.variables = [ "--all" ];

    settings = {
      "$mod" = "SUPER";
      "$modMod" = "SUPER SHIFT";
      "$terminal" = "kitty";
      "$menu" = "fuzzel";

      bind = [
        "$mod, d, exec, $menu"
        "$mod, Return, exec, $terminal"
        "$mod, x, killactive"
        "$mod, e, exec, bemoji -n"
        "$mod, o, exec, powermenu"
        "$modMod, o, exit"
        "$modMod, w, exec, pkill waybar; waybar &"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$modMod, h, swapwindow, l"
        "$modMod, j, swapwindow, d"
        "$modMod, k, swapwindow, u"
        "$modMod, l, swapwindow, r"

        "$mod, f, fullscreen"
        "$mod, t, togglefloating"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$modMod, 1, movetoworkspacesilent, 1"
        "$modMod, 2, movetoworkspacesilent, 2"
        "$modMod, 3, movetoworkspacesilent, 3"
        "$modMod, 4, movetoworkspacesilent, 4"
        "$modMod, 5, movetoworkspacesilent, 5"
        "$modMod, 6, movetoworkspacesilent, 6"
        "$modMod, 7, movetoworkspacesilent, 7"
        "$modMod, 8, movetoworkspacesilent, 8"
        "$modMod, 9, movetoworkspacesilent, 9"
        "$modMod, 0, movetoworkspacesilent, 10"
      ];

      bindl = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      exec-once = [
        "waybar &"
        "swayidle -w before-sleep 'hyprlock'"
      ];

      input = {
        kb_layout = "us";
        kb_options = "ctrl:swapcaps";
      };

      animations = {
        animation = [
          "global, 1, 3, default"
        ];
      };

      general = {
        "col.active_border" = "rgba(eb6f92ee)";
        "col.inactive_border" = "rgba(6e6a86aa)";
      };

      env = [
        "NIXOS_OZONE_WL,1"
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${./wallpaper.png}" ];
      wallpaper = [ ",${./wallpaper.png}" ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
      };
      background = {
        path = "${./wallpaper.png}";
        blur_passes = 1;
      };

      input-field = {
        size = "200, 50";
        rounding = 0;
        outer_color = "rgba(235, 111, 146, 1.0)";
        inner_color = "rgba(31, 29, 46, 1.0)";
        font_color = "rgba(224, 222, 244, 1.0)";
        check_color = "rgba(49, 116, 143, 1.0)";
        fail_color = "rgba(246, 193, 119, 1.0)";
        outline_thickness = 2;
        fade_timeout = 5000;
        position = "0, -120";
      };

      label = [
        {
          text = "$USER";
          color = "rgba(235, 111, 146, 1.0)";
          font_size = 50;
          font_family = "Monospace";
          position = "0, 120";
        }

        {
          text = "$TIME12";
          color = "rgba(235, 111, 146, 1.0)";
          font_size = 100;
          font_family = "Monospace";
        }
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings.mainbar = {
      modules-left = [
        "hyprland/workspaces"
        "tray"
      ];
      modules-right = [
        "disk"
        "memory"
        "temperature"
        "network"
        "wireplumber"
        "battery"
        "clock"
      ];

      clock = {
        format = "{:%a, %b %d, %Y %I:%M %p}";
      };

      battery = {
        format = "{icon}{capacity}%";
        format-icons = [
          "🪫"
          "🔋"
        ];
        states = {
          low = 15;
        };
      };

      wireplumber = {
        format = "{icon}{volume}%";
        format-icons = [
          "🔈"
          "🔉"
          "🔊"
        ];
        format-muted = "🔇{volume}%";
      };

      network = {
        format-wifi = "🛜{essid}";
        format-ethernet = "🔗{essid}";
        format-disconnected = "🚫no network";
      };

      temperature = {
        format = "🌡️{temperatureC}°C";
      };

      memory = {
        format = "🐏{percentage}%";
      };

      disk = {
        format = "📚{percentage_used}%";
      };
    };
    style = ''
      * {
        font-weight: bold;
        color: #e0def4;
      }

      window#waybar {
        background: transparent;
      }

      .modules-left, .modules-right {
        margin: 5px;
      }


      .modules-left > * > *,
      .modules-right > * > * {
        margin: 0 3px;
        padding: 0 5px;
        background: #524f67;
      }

      #workspaces {
        padding: 0;
      }

      #workspaces button {
        padding: 0 5px;
        border-radius: 0;
      }

      #workspaces button.active {
        background: #eb6f92;
      }
    '';
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      cursor = "#e0def4";
      cursor_text_color = "#191724";
    };
    themeFile = "rose-pine";
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";

    history = {
      append = true;
      ignoreAllDups = true;
    };

    initContent = lib.mkOrder 1000 ''
      bindkey '^ ' autosuggest-accept

      setopt PROMPT_SUBST

      autoload -Uz vcs_info
      precmd() { vcs_info }

      git_bg_color() {
        local git_dir=$(git rev-parse --show-toplevel 2>/dev/null)
        if [[ -n "$git_dir" ]]; then
          # repo exists
          if [[ -n $(git status --porcelain) ]]; then
            echo 3
          else
            echo 2
          fi
        else
          echo 0
        fi
      }

      zstyle ':vcs_info:git:*' formats '%b %m'
      zstyle ':vcs_info:git:*' actionformats '%b (%a) %m'

      PROMPT='%B'
      PROMPT+='%K{4}%F{0} %n@%m %k%f'
      PROMPT+='%K{5}%F{0} %~ %k%f'
      PROMPT+='%K{$(git_bg_color)}%F{0} ''${vcs_info_msg_0_}%k%f'
      PROMPT+='%(?..%K{1}%F{0} ✘ %? %k%f)'
      PROMPT+=' ❯ '
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
      };
      colors = let
        highlight = "f6c177ff";
      in {
        background = "191724ff";
        text = "e0def4ff";
        prompt = "${highlight}";
        placeholder = "6e6a86ff";
        input = "${highlight}";
        match = "${highlight}";
        selection = "6e6a86ff";
        selection-text = "191724ff";
        selection-match = "${highlight}";
        border = "eb6f92ff";
      };
      border = {
        radius = 0;
      };
    };
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 37.665531;
    longitude = -122.448372;
    temperature.night = 2000;
  };

  programs.ranger = {
    enable = true;
    settings = {
      preview_images = true;
      preview_images_method = "kitty";
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 400;
        offset = "5x5";

        progress_bar_min_width = 380;
        progress_bar_max_width = 380;
        progress_bar_corner_radius = 2;

        padding = 10;
        horizontal_padding = 10;
        frame_width = 1;
        gap_size = 3;
        font = "Monospace 14";

        icon_theme = "rose-pine";
        enable_recursive_icon_lookup = true;

        background = "#26233a";
        foreground = "#e0def4";
      };

      urgency_low = {
        background = "#26273d";
        highlight = "#31748f";
        frame_color = "#31748f";
        default_icon = "dialog-information";
        format = "<b><span foreground='#31748f'>%s</span></b>\n%b";
      };

      urgency_normal = {
        background = "#362e3c";
        highlight = "#f6c177";
        frame_color = "#f6c177";
        default_icon = "dialog-warning";
        format = "<b><span foreground='#f6c177'>%s</span></b>\n%b";
      };

      urgency_critical = {
        background = "#35263d";
        highlight = "#eb6f92";
        frame_color = "#eb6f92";
        default_icon = "dialog-error";
        format = "<b><span foreground='#eb6f92'>%s</span></b>\n%b";
      };
    };
  };

  home.file.".local/bin/powermenu" = {
    source = ./bin/powermenu.sh;
    executable = true;
  };

  # you should not change this value, even if you update home manager
  home.stateVersion = "25.05"; # Did you read the comment?
}
