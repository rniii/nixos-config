{ lib, pkgs, ... }:


let
  sources = import ../npins;
in
{
  imports =
    with import ../npins;
    [ ../common/default.nix
    ];

  networking.firewall.enable = true;

  users.users.openbench =
    { isNormalUser = true;
      openssh.authorizedKeys.keys =
        [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAHsUKVtmPC/QgaisBCG7oDJDF2fIn1Jn/rTvgjIrMP lily@tulip"
        ];
    };

  environment.systemPackages = with pkgs;
    [ screen
    ];
}
