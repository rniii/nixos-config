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
│   └── tulip.nix           --  desktop, Thinkpad T14 Gen 6 [AMD Ryzen AI 7 PRO 350]  (2025/08/29)
├── npins/
│   └── ...
├── default.nix             -- Plain NixOS config object, evaluates selected host
├── pubkeys.nix             -- SSH keys for in-network access
└── README.md
```
