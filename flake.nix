{
    inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
    inputs.nixpkgs-frozen.url = "nixpkgs/nixos-26.05";

    inputs.nixos-hardware = "nixos-hardware";

    outputs = { self, nixpkgs }@inputs: let
        inherit (nixpkgs) lib;

        forEachHost = lib.genAttrs [
            "aaya"
            "atri"
            "compute2"
            "testvm"
            "tulip"
        ];
    in {
        nixosConfigurations = forEachHost (host: {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/${host}.nix ];
        });
    };
}
