{ pkgs, ... }:

let
  sources = import ../npins;
  pkgs-frozen = import sources.nixpkgs-frozen { config.allowUnfree = true; };
  pkgs-unstabler = import sources.nixpkgs-unstabler { config.allowUnfree = true; };
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
      plugins = with pkgs.obs-studio-plugins;
        [ input-overlay ];
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
      obs-cmd
      osu-lazer-bin
      prismlauncher
      syncplay
      signal-desktop
      vesktop

      # tuis
      lazygit
      (callPackage ../pkgs/neovim/package.nix { })
      taskwarrior3
      timewarrior

      # other
      aria2
      ffmpeg
      pkgs-frozen.jiten
      mpd
      mpd-mpris
      mpc
      (ncmpcpp.override
        { visualizerSupport = true;
        })
      playerctl
      qpwgraph
      rsgain
      wl-clipboard
      pkgs-unstabler.yt-dlp
    ];
}
