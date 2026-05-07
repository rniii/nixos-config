{ config, ... }:

{
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  services.tailscale =
    { enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

  networking.firewall =
    { trustedInterfaces = [ config.services.tailscale.interfaceName ];
    };
}
