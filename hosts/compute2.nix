{ lib, ... }:

{
    imports = [
        ../compute
    ];

    networking.hostName = "compute2";

    services.openssh = {
        ports = [ 22 29793 ];

        extraConfig = ''
            Match LocalPort 29793
                AllowUsers git
            Match all
        '';
    };

    services.tangled = {
        knot = {
            enable = true;
            gitUser = "git";
            stateDir = "/var/lib/tangled-knot";
            repo.scanPath = "${services.tangled.knot.stateDir}/repos";
            server = {
                listenAddr = "0.0.0.0:29794";
                hostname = "knot.87flowers.com";
                internalListenAdr = "127.0.0.1:29795";
                owner = "did:plc:nu2smxstuurftjhruoag2b6w";
            };
        };
    };

    # nixos-generate-config --show-hardware-config

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-label/EFI";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
    };

    swapDevices = [
        { device = "/dev/disk/by-label/swap"; }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = true;
}
