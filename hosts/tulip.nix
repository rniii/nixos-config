let
  inherit (import ../npins) nixos-hardware;
in {
  imports =
    [ ../modules/common.nix
      ../modules/pc.nix

      "${nixos-hardware}/lenovo/thinkpad/e14"
      "${nixos-hardware}/common/cpu/amd"
      "${nixos-hardware}/common/gpu/amd"
      "${nixos-hardware}/common/cpu/amd/pstate.nix"

    ];

  networking.hostName = "tulip";
}
