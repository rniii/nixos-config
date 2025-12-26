let
  inherit (import ../npins) nixos-hardware;
in {
  imports =
    [ ../desktop

      "${nixos-hardware}/lenovo/thinkpad/t14"
      "${nixos-hardware}/common/cpu/amd"
      "${nixos-hardware}/common/gpu/amd"
    ];

  networking.hostName = "tulip";
}
