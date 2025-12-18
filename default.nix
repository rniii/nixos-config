let
  sources = import ./npins;
  evalCfg = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";
in
  builtins.foldl'
    (cfgs: host: cfgs // { ${host} = evalCfg { modules = [ ./hosts/${host}.nix ]; }; })
    {} [ "aaya" "compute2" "tulip" ]
