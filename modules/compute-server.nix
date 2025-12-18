{ pkgs, lib, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  users.users.openbench =
    { isNormalUser = true;
      openssh.authorizedKeys.keys =
        [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPAHsUKVtmPC/QgaisBCG7oDJDF2fIn1Jn/rTvgjIrMP lily@tulip"
        ];
    };

  environment.systemPackages =
    with pkgs;
      [ gnumake
        gcc_multi
        clang
        python314
        rustup
        git
        screen
        neovim
      ];
}
