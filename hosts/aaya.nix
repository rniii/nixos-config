let
  inherit (import ../npins) nixos-hardware;
in {
  imports =
    [ ../modules/common.nix
      ../modules/pc.nix

      # XXX: lily can use this s/e14/t14/, there is also no T14 Gen 6 config yet
      "${nixos-hardware}/lenovo/thinkpad/e14"
      "${nixos-hardware}/common/cpu/amd"
      "${nixos-hardware}/common/gpu/amd"
      "${nixos-hardware}/common/cpu/amd/pstate.nix" # XXX and tell me if this is worth it

      # XXX: P.S. might be worth contributing to nixos-hardware later
    ];

  networking.hostName = "aaya";

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
}
