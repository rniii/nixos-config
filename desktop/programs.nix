{ pkgs, ... }:

let
  sources = import ../npins;
  pkgs-frozen = import sources.nixpkgs-frozen { config.allowUnfree = true; };
in
{
  programs.appimage.enable = true;  # osu-lazer

  programs.steam =
    { enable = true;
      extraCompatPackages = with pkgs;
        [ proton-ge-bin ];
    };

  programs.obs-studio =
    { enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
        # obs-multi-rtmp
      ];
    };

  programs.neovim =
    { enableLspPlugins = true;
      vimOptions =
        { guifont = "Sarasa Term J";
        };
      vimGlobals =
        { neovide_floating_blur_amount_x = 0;
          neovide_floating_blur_amount_y = 0;
        };
    };

  environment.variables =
    rec
    { EDITOR = "nvim";
      VISUAL = EDITOR;
    };

  environment.systemPackages = with pkgs;
    [ # gui applications
      pkgs-frozen.aseprite # slow
      darktable
      gimp
      keepassxc
      krita
      mesa-demos
      mpv
      neovide
      obs-cmd
      osu-lazer-bin
      prismlauncher
      syncplay
      signal-desktop
      vesktop

      # tuis
      lazygit
      taskwarrior3
      timewarrior

      # other
      aria2
      ffmpeg
      pkgs-frozen.jiten
      listenbrainz-mpd
      mpd
      mpd-mpris
      mpc
      (ncmpcpp.override
        { visualizerSupport = true;
        })
      pi-coding-agent
      playerctl
      qpwgraph
      rsgain
      wl-clipboard
      yt-dlp
    ];
}
