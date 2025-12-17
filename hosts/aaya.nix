let
  inherit (import ../npins) nixos-hardware;
in {
  imports =
    [ ../modules/common.nix
      ../modules/pc.nix

      # XXX: lily can use this s/e14/t14/, there is also no T14 Gen 6 config yet
      "${nixos-hardware}/lenovo/thinkpad/e14"
      "${nixos-hardware}/common/cpu/amd"
      "${nixos-hardware}/common/gpu/amd"
      "${nixos-hardware}/common/cpu/amd/pstate.nix" # XXX and tell me if this is worth it

      # XXX: P.S. might be worth contributing to nixos-hardware later
    ];

  networking.hostName = "aaya";
}
