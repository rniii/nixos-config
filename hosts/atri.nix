{ lib, pkgs, ... }:
{
  imports =
    with import ../npins;
    [ ../compute
    ];

  networking.hostName = "atri";
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  hardware.firmware = [ pkgs.linux-firmware ];

  # nixos-generate-config --show-hardware-config

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}

