{
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        nixpkgs-frozen.url = "nixpkgs/nixos-26.05";
        nixos-hardware.url = "nixos-hardware";
    };

    outputs = { self, nixpkgs, ... }@inputs: let
        inherit (nixpkgs) lib;

        forEachHost = lib.genAttrs [
            "aaya"
            "atri"
            "compute2"
            "testvm"
            "tulip"
        ];
    in {
        nixosConfigurations = forEachHost (host: lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/${host}.nix ];
        });
    };
}
