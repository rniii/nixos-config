{ pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  system.stateVersion = "25.11"; # yes, i did read the comment

  # XXX: server could probably use UKI or something
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
