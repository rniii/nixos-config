{
  imports =
    [ ../modules/common.nix
      ../modules/compute-server.nix
    ];

  networking.hostName = "compute2";
}
