{ lib, inputs, ... }:

{
    imports = with inputs.nixos-hardware.nixosModules; [
        ../desktop

        lenovo-thinkpad-e14
        common-cpu-amd
        common-gpu-amd
        common-cpu-amd-pstate
    ];

    networking.hostName = "aaya";
    i18n.defaultLocale = lib.mkForce "ja_JP.UTF-8";
    programs.firefox.languagePacks = [ "ja" ];

    hardware.bluetooth.enable = true;

    services.broadcast-box.enable = true;

    services.sunshine = {
        enable = true;
        autoStart = false;
        openFirewall = true;
        capSysAdmin  = true;
    };

    services.navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
            Address = "0.0.0.0";
            MusicFolder = "/home/rini/Music";
            Jukebox.Enabled = true;
        };
    };

    systemd.services.navidrome.serviceConfig = {
        ProtectHome = lib.mkForce "tmpfs";
    };

    services.tailscale.extraSetFlags = [
        "--accept-dns=false"
        "--accept-routes=false"
        "--netfilter-mode=off"
    ];

    networking.interfaces.tailscale0.ipv4.routes = [
        { address = "100.64.0.0"; prefixLength = 10; }
    ];

    services.mullvad-vpn.enable = true;

    networking.firewall.checkReversePath = "loose";

    networking.nftables.tables.mullvad-tailscale = {
        family = "inet";
        content = ''
            chain prerouting {
                type filter hook prerouting priority -100; policy accept;

                ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
                ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
            }

            chain outgoing {
                type route hook output priority -100; policy accept;
                ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
            }
      '';
    };

    # nixos-generate-config

    hardware.enableRedistributableFirmware = true;

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems = let
        bootPart = {
            device  = "/dev/disk/by-uuid/CAED-F7C3";
            fsType  = "vfat";
            options = [ "umask=0077" ];
        };

        mkSubvol = name: options: {
            device  = "/dev/disk/by-uuid/fa4c70d3-1e21-4cc0-bc5b-a4f868b80cb0";
            fsType  = "btrfs";
            options = [ "subvol=${name}" ] ++ options;
        };
    in {
        "/boot" = bootPart;
        "/"     = mkSubvol "root" [ "noatime" "compress" ];
        "/nix"  = mkSubvol "nix"  [ "noatime" "compress" ];
        "/home" = mkSubvol "home" [ "noatime" ];
    };

    swapDevices = [
        { device = "/dev/disk/by-uuid/57bda0f8-3329-4653-9656-a116b79fcbcd"; }
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = true;
}
