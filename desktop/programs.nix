{ lib, pkgs, ... }:

let
  sources = import ../npins;
  pkgs-unstabler = import sources.nixpkgs-unstabler { config.allowUnfree = true; };
in
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg)
      [ "aseprite"
        "steam" "steam-unwrapped"
        # "osu-lazer-bin"
      ];

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
      aseprite
      gimp
      keepassxc
      krita
      mpv
      obs-cmd
      pkgs-unstabler.osu-lazer-bin
      prismlauncher
      syncplay
      signal-desktop
      pkgs-unstabler.vesktop

      # tuis
      lazygit
      (callPackage ../pkgs/neovim/package.nix { })

      # other
      ffmpeg
      qpwgraph
      wl-clipboard
    ];
}
