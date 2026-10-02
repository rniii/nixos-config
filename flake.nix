{
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        nixpkgs-frozen.url = "nixpkgs/nixos-26.05";
        nixos-hardware.url = "nixos-hardware";
    };

    outputs = { self, nixpkgs, ... }@inputs: let
        inherit (nixpkgs) lib;

        forAllHosts = lib.genAttrs [
            "aaya"
            "atri"
            "compute2"
            "testvm"
            "tulip"
        ];

        forAllSystems = lib.genAttrs [
            "x86_64-linux"
        ];

        # forAllSystems = with lib; genAttrs (pipe self.nixosConfigurations [
        #     attrValues
        #     (map (c: c.config.nixpkgs.hostPlatform.system))
        #     uniqueStrings
        # ]);
    in {
        packages = forAllSystems (system: with nixpkgs.legacyPackages.${system}; {
            discord-rich-presence-nvim = callPackage
                ./pkgs/discord-rich-presence.nvim/package.nix {};
            neov-ime-nvim = callPackage
                ./pkgs/neov-ime-nvim/package.nix {};
            twoslash-queries-nvim = callPackage
                ./pkgs/twoslash-queries-nvim/package.nix {};
        });

        nixosConfigurations = forAllHosts (host: lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/${host}.nix ];
        });
    };
}
