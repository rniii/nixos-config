{ lib, pkgs, ... }:

{
    imports = [
        ./neovim
        ./networking.nix
        ./programs.nix
        ./shell.nix
    ];

    system.stateVersion = "25.11"; # yes, i did read the comment

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    services.sshd.enable = true;

    time.timeZone = null;
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    users.users = let
        pubkeys = import ../pubkeys.nix;
    in (
        lib.genAttrs [ "rini" "lily" ] (_: {
            isNormalUser = true;
            openssh.authorizedKeys.keys = pubkeys;
            shell = pkgs.fish;
        })
    );

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.channel.enable = false;

    nixpkgs.config.allowUnfree = true;
}
