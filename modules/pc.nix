{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg)
      [ "aseprite"
        "steam" "steam-unwrapped"
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
      autoConfig = ''
        pref("datareporting.healthreport.uploadEnabled", false);
        pref("browser.ctrlTab.sortByRecentlyUsed", true);
        pref("full-screen-api.ignore-widgets", true);
        pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
      '';
      preferences =
        { "browser.aboutConfig.showWarning" = false;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          # newtab sponsor stuff
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";
          # tracking protection
          "browser.contentblocking.category" = "strict";
          # give firefox some amnesia
          "browser.privatebrowsing.autostart" = true;
        };
      policies =
        { SearchEngines.Remove = [ "Google" "Bing" ];
          GenerativeAI.Chatbot = false;
          GenerativeAI.LinkPreviews = false;
        };
    };

  programs.steam.enable = true;

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

      neovim
    ];
}
