{ lib, inputs, pkgs, ... }:

{
    imports = with inputs; [
        ../compute
        tangled.nixosModules.knot-rs
    ];

    networking.hostName = "compute2";

    services.tangled.knot-rs = {
        enable = true;
        # echo KNOT_MASTER_KEY="$(openssl rand -base64 32)" >/etc/knot/knot.env
        environmentFile = "/etc/knot/knot.env";
        settings.server = {
            hostname = "knot.87flowers.com";
            admins = [
                "did:plc:nu2smxstuurftjhruoag2b6w" # @lily.tngl.sh
                "did:plc:boexphx7aijdxxciuvpkmyjh" # @rini.tngl.sh
            ];
        };
        settings.xrpc.trusted_proxy_header = "x-forwarded-for";
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
