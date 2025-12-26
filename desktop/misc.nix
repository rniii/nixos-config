{ pkgs, ... }:

{
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
}
