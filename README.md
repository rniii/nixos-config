# NixOS config

```
$ tree
./
├── common/
│   ├── default.nix         -- Config applied to both server and desktop hosts
│   └── ...
├── compute/
│   ├── default.nix         -- Config applied to server hosts
│   └── ...
├── desktop/
│   ├── default.nix         -- Config applied to desktop hosts
│   └── ...
├── hosts/                  -- Per-host entrypoints:
│   ├── aaya.nix            --  desktop, Thinkpad E14 Gen 6 [AMD Ryzen 7 7735HS]      (2025/07/24)
│   ├── compute2.nix        --  compute, Mini-ITX board [AMD Ryzen 9 7940HX]          (2024/08/20)
│   ├── tulip.nix           --  desktop, Thinkpad T14 Gen 6 [AMD Ryzen AI 7 PRO 350]  (2025/08/29)
│   └── testvm.nix          --  for use with build-vm
├── npins/
│   └── ...
├── default.nix             -- Plain NixOS config object, evaluates selected host
├── pubkeys.nix             -- SSH keys for in-network access
└── README.md
```

## Chores

- `hardware-configuration.nix` should probably no longer be kept in `/etc/nixos`
- i kinda don't like home manager but i want KDE to be configured through nix
  - really just make a systemd user unit with a bunch of `cat > .config/kgoogleballs <<EOF`
  - the hard part is dropping all the default options KDE puts in like 30 different files and only keeping what actually changed
  - everything else is configured system-wide
- `common/` still has stuff in `default.nix` besides imports (im lazy)
- `desktop/` has a `misc.nix` which might be too lazy
- i'll make a good nvim config i swear
