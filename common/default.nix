{ lib, pkgs, ... }:

let
  pubkeys = import ../pubkeys.nix;
in {
  imports =
    [ # from nixos-generate-config
      /etc/nixos/hardware-configuration.nix

      ./programs.nix
    ];

  system.stateVersion = "25.11"; # yes, i did read the comment

  # XXX: server could probably use UKI or something
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  services.tailscale =
    { enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };


  services.sshd.enable = true;

  time.timeZone = null;
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  users.users.rini =
    { isNormalUser = true;
      openssh.authorizedKeys.keys = pubkeys;
    };

  users.users.lily =
    { isNormalUser = true;
      openssh.authorizedKeys.keys = pubkeys;
    };

  nix.nixPath =
    let sources = import ../npins; in [ "nixpkgs=${sources.nixpkgs}" ];
}
