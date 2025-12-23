{ pkgs, lib, ... }:

{
  imports =
    [ ../desktop
    ];

  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg)
      [ "aseprite"
        "steam" "steam-unwrapped"
        "osu-lazer-bin"
      ];

  programs.appimage.enable = true;  # required for some packages

  # desktop
  security.rtkit.enable = true;
  services.pipewire =
    { enable = true;
      pulse.enable = true;
    };

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.inputMethod =
    { enable = true;
      type   = "fcitx5";
      fcitx5.addons = with pkgs;
        [ fcitx5-mozc-ut ];
    };

  fonts.packages =
    with pkgs;
    [ noto-fonts-cjk-sans
      sarasa-gothic
      liberation_ttf
      lmodern
    ];

  # programs
  programs.steam =
    { enable = true;
      extraCompatPackages = with pkgs;
        [ proton-ge-bin ];
    };

  environment.systemPackages =
    with pkgs;
    [ aseprite
      gimp
      keepassxc
      krita
      osu-lazer-bin
      prismlauncher
      signal-desktop
      vesktop

      lazygit
      neovim
    ];
}
