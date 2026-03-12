{ pkgs, ... }:

{
  imports =
    [ ../common
    ];

  users.users.openbench =
    { isNormalUser = true;
      openssh.authorizedKeys.keys =
        [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAHsUKVtmPC/QgaisBCG7oDJDF2fIn1Jn/rTvgjIrMP lily@tulip"
        ];
    };

  environment.systemPackages = with pkgs;
    [ gnumake
      gcc_multi
      clang
      python314
      rustup
      screen
    ];
}
