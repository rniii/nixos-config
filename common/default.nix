{ lib, pkgs, ... }:

{
  imports =
    [ ./networking.nix
      ./programs.nix
    ];

  system.stateVersion = "25.11"; # yes, i did read the comment

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
