{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg)
      [ "steam" "steam-unwrapped"
        "osu-lazer-bin"
      ];

  programs.appimage.enable = true;  # required for some packages

  # desktop
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  environment.plasma6.excludePackages =
    with pkgs.kdePackages; [ plasma-browser-integration kwin-x11 ];

  security.rtkit.enable = true;
  services.pipewire.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.inputMethod =
    { enable = true;
      type   = "fcitx5";
      fcitx5.addons = [ pkgs.fcitx5-mozc-ut ];
    };

  fonts.packages =
    with pkgs;
    [ noto-fonts-cjk-sans
      sarasa-gothic
      liberation_ttf
      lmodern
    ];

  # networking
  networking.networkmanager.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  services.tailscale =
    { enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

  # programs
  programs.firefox =
    { enable  = true;
      package = pkgs.firefox-devedition;
    };

  programs.steam.enable = true;

  environment.systemPackages =
    with pkgs;
    [ aseprite
      gimp
      keepassxc
      krita
      librewolf
      osu-lazer-bin
      signal-desktop
      vesktop

      neovim
    ];
}
