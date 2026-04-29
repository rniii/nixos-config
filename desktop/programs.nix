{ lib, pkgs, ... }:

let
  sources = import ../npins;
  pkgs-frozen = import sources.nixpkgs-frozen { config.allowUnfree = true; };
  # pkgs-unstabler = import sources.nixpkgs-unstabler { config.allowUnfree = true; };
in
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg)
      [ "aseprite"
        "steam" "steam-unwrapped"
        "osu-lazer-bin"
      ];

  programs.appimage.enable = true;  # osu-lazer

  programs.nix-ld.enable = true;

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
      gimp
      keepassxc
      krita
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

      # other
      ffmpeg
      qpwgraph
      wl-clipboard
    ];
}
