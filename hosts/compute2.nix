{
  imports =
    [ ../modules/common.nix
      ../modules/compute-server.nix
    ];

  services.tailscale =
    { enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

  networking.hostName = "compute2";
}
