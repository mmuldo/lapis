{
  lib,
  ...
}:
{
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

    settings = {
      "$mod" = "SUPER";
      "$modMod" = "SUPER SHIFT";
      "$terminal" = "kitty";
      "$menu" = "wofi --show drun";

      bind = [
        "$mod, d, exec, $menu"
        "$mod, Return, exec, $terminal"
        "$mod, x, killactive"
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

      exec-once = [ "waybar &" ];

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
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${./wallpaper.png}" ];
      wallpaper = [ ",${./wallpaper.png}" ];
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

  programs.wofi = {
    enable = true;
    style = ''
      window {
        margin: 0px;
        background-color: #191724;
        border-radius: 0px;
        border: 2px solid #eb6f92;
        color: #e0def4;
        font-size: 20px;
      }

      #input {
        margin: 5px;
        border-radius: 0px;
        border: none;
        border-radius: 0px;;
        color: #eb6f92;
        background-color: #26233a;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: #26233a;
        color: #191724;
        border-radius: 0px;
      }

      #outer-box {
        margin: 15px;
        border: none;
        background-color: #191724;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #e0def4;
      } 

      #entry:selected {
        background-color: #eb6f92;
        color: #191724;
        border-radius: 0px;;
        outline: none;
      }

      #entry:selected * {
        background-color: #eb6f92;
        color: #191724;
        border-radius: 0px;;
        outline: none;
      }
    '';
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

  # you should not change this value, eve if you update home manager
  home.stateVersion = "25.05"; # Did you read the comment?
}
