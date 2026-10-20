{ lib, pkgs, ... }:

{
    system.stateVersion = "25.11"; # yes, i did read the comment

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    services.openssh.enable = true;

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

    programs.mosh.enable = true;
    programs.nano.enable = false;
    programs.neovim.enable = true;

    programs.fish = {
        enable = true;
        promptInit = ''
            set -g fish_color_command --reset
            set -g fish_color_param --reset

            function fish_prompt
                echo -n -s \
                    (set_color magenta --bold) (prompt_hostname) " " \
                    (set_color cyan --reset) (prompt_pwd) (fish_vcs_prompt) "> " \
                    (set_color --reset)
            end

            function fish_right_prompt
                set -l lastpipestatus $pipestatus
                __fish_print_pipestatus \
                    "" " :<" "|" (set_color red) (set_color --bold) \
                    $lastpipestatus
            end
        '';
    };

    environment.systemPackages = with pkgs; [
        # sysadmin
        bubblewrap
        dig
        ed
        git
        inetutils
        nmap
        p7zip
        rsync
        sqlite-interactive
        tree
        unzip
        vim
        zip

        # shell
        ascii
        cowsay
        hyperfine
        jp2a
        jq
        libqalculate # qalc cli
        ripgrep

        # pokey tools
        asar
        binutils
        file
        patchelf
        pretty-simple
        radare2
        socat
        strace

        # doc
        man-pages
        man-pages-posix
    ];
}
