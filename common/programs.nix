{ pkgs, ... }:

{
  programs.mosh.enable = true;

  environment.systemPackages = with pkgs;
    [ # devel
      git

      # nixing
      npins

      # sysadmin
      nmap
      p7zip
      rsync
      tree

      # shell
      ascii
      cowsay
      hyperfine
      jp2a
      jq
      libqalculate # qalc cli
      ripgrep

      # pokey tools
      asar
      binutils
      file
      radare2
      strace
    ];
}
