{ lib, ... }:
{
  imports =
    with import ../npins;
    [ ../desktop

      "${nixos-hardware}/lenovo/thinkpad/t14"
      "${nixos-hardware}/common/cpu/amd"
      "${nixos-hardware}/common/gpu/amd"
      "${nixos-hardware}/common/cpu/amd/pstate.nix"
    ];

  networking.hostName = "tulip";
  networking.firewall.checkReversePath = "loose";

  services.mullvad-vpn.enable = true;
  networking.interfaces.tailscale0.ipv4.routes =
   [ { address = "100.64.0.0"; prefixLength = 10; } ];

  services.tailscale.extraSetFlags =
    [ "--accept-dns=false" "--accept-routes=false" ];

  networking.nftables.tables = {
    mullvad_tailscale = {
      family = "inet";
      content = ''
        chain output {
          type route hook output priority -100; policy accept;
          oifname "tailscale0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65
        }
        chain prerouting {
          type filter hook prerouting priority -100; policy accept;
          ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        }
      '';
    };
  };

  # nixos-generate-config --show-hardware-config

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
