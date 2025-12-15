{ pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  system.stateVersion = "25.11"; # yes, i did read the comment

  # XXX: server could probably use UKI or something
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.sshd.enable = true;

  time.timeZone = null;
  i18n.defaultLocale = "en_US.UTF-8";

  # XXX: aaaaaaaaaaaaaaaaaaaaaaaaaaaa keysssssss
  users.users.rini =
    { isNormalUser = true;
      openssh.authorizedKeys.keys =
        [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfUHDcpgeZnJIZ0PyJKWx7f5xeV8Tq9ppX7vbXKZjto lily@tulip"
        ];
    };

  users.users.lily =
    { isNormalUser = true;
      openssh.authorizedKeys.keys =
        [
        ];
    };
}
