{ lib, ... }:

{
  imports =
    with import ../npins;
    [ ../desktop

      "${nixos-hardware}/lenovo/thinkpad/e14"
      "${nixos-hardware}/common/cpu/amd"
      "${nixos-hardware}/common/gpu/amd"
      "${nixos-hardware}/common/cpu/amd/pstate.nix"
    ];

  networking.hostName = "aaya";
  i18n.defaultLocale = lib.mkForce "ja_JP.UTF-8";
  programs.firefox.languagePacks = [ "ja" ];

  hardware.bluetooth.enable = true;

  services.broadcast-box.enable = true;

  services.sunshine =
    { enable       = true;
      openFirewall = true;
      capSysAdmin  = true;
      autoStart    = false;
    };

  services.tailscale.extraSetFlags =
    [ "--accept-dns=false" "--accept-routes=false" ];

  networking.interfaces.tailscale0.ipv4.routes =
    [ { address = "100.64.0.0"; prefixLength = 10; } ];

  services.mullvad-vpn.enable = true;

  networking.firewall.checkReversePath = "loose";

  networking.nftables.tables = {
    mullvad-tailscale = {
      family = "inet";
      content = ''
        chain output {
          ip daddr 100.64.0.0/10 accept
        }
        chain input {
          ip saddr 100.64.0.0/10 accept
        }
      '';
    };
  };

  # nixos-generate-config

  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems =
    let
      bootPart =
        { device  = "/dev/disk/by-uuid/CAED-F7C3";
          fsType  = "vfat";
          options = [ "umask=0077" ];
        };
      mkSubvol =
        name: options:
        { device  = "/dev/disk/by-uuid/fa4c70d3-1e21-4cc0-bc5b-a4f868b80cb0";
          fsType  = "btrfs";
          options = [ "subvol=${name}" ] ++ options;
        };
    in
    { "/boot" = bootPart;
      "/"     = mkSubvol "root" [ "noatime" "compress" ];
      "/nix"  = mkSubvol "nix"  [ "noatime" "compress" ];
      "/home" = mkSubvol "home" [ "noatime" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/57bda0f8-3329-4653-9656-a116b79fcbcd"; }
    ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
