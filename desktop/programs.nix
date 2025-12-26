{ lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg)
      [ "aseprite"
        "steam" "steam-unwrapped"
        "osu-lazer-bin"
      ];

  programs.appimage.enable = true;  # osu-lazer

  programs.steam =
    { enable = true;
      extraCompatPackages = with pkgs;
        [ proton-ge-bin ];
    };

  environment.systemPackages = with pkgs;
    [ # gui applications
      aseprite
      gimp
      keepassxc
      krita
      osu-lazer-bin
      prismlauncher
      signal-desktop
      vesktop

      # tuis
      lazygit
      neovim
    ];
}
