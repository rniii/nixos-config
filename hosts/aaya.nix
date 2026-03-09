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

  services.broadcast-box.enable = true;

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
