let
  inherit (import ./npins) nixpkgs;

  lib = import "${nixpkgs}/lib";
in
  lib.genAttrs [ "aaya" "atri" "compute2" "testvm" "tulip" ] (host:
    import "${nixpkgs}/nixos"
      { configuration = ./hosts/${host}.nix;
      })
