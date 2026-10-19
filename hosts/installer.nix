{ modulesPath, ... }:

{
    imports = [
        ../common
        "${modulesPath}/installer/netboot/netboot-minimal.nix"
    ];

    users.users.root.openssh.authorizedKeys.keys = import ../pubkeys.nix;
    services.openssh.enable = true;

    nixpkgs.hostPlatform = "x86_64-linux";
}
