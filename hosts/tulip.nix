{
  imports =
    with import ../npins;
    [ ../desktop

      "${nixos-hardware}/lenovo/thinkpad/t14"
      "${nixos-hardware}/common/cpu/amd"
      "${nixos-hardware}/common/gpu/amd"
      "${nixos-hardware}/common/cpu/amd/pstate.nix"
    ];

  networking.hostName = "tulip";
}
