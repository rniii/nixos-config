let
  inherit (import ../npins) nixos-hardware;
in {
  imports =
    [ ../modules/common.nix
      ../modules/pc.nix

      "${nixos-hardware}/lenovo/thinkpad/t14"
      "${nixos-hardware}/common/cpu/amd"
      "${nixos-hardware}/common/gpu/amd"
    ];

  networking.hostName = "tulip";
}
