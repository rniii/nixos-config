let
  sources = import ./npins;
  pkgs    = import sources.nixpkgs {};
  evalCfg = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";
in
  builtins.foldl'
    (cfgs: host: cfgs // { ${host} = evalCfg { modules = [ ./hosts/${host}.nix ]; }; })
    {} [ "aaya" "tulip" ]
