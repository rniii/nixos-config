with import ./npins;
with import nixpkgs {
    config.allowUnfree = true;
};

lib.genAttrs [
    "aaya"
    "atri"
    "compute2"
    "testvm"
    "tulip"
] (host: nixos ./hosts/${host}.nix)
