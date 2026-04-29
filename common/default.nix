{ lib, pkgs, ... }:

{
  imports =
    [ ./programs.nix
    ];

  system.stateVersion = "25.11"; # yes, i did read the comment

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
  networking.nftables.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  services.tailscale =
    { enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

  services.sshd.enable = true;

  time.timeZone = null;
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  users.users =
    let pubkeys = import ../pubkeys.nix; in
    { rini =
        { isNormalUser = true;
          openssh.authorizedKeys.keys = pubkeys;
        };
      lily =
        { isNormalUser = true;
          openssh.authorizedKeys.keys = pubkeys;
        };
    };

  nix =
    { nixPath = with import ../npins; [ "nixpkgs=${nixpkgs}" ];
      settings =
        { experimental-features = [ "nix-command" "flakes" ];
        };
    };
}
