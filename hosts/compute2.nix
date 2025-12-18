{
  imports =
    [ ../modules/common.nix
      ../modules/compute.nix
    ];

  networking.hostName = "compute2";
}
