{ pkgs, ... }:

{
  programs.mosh.enable = true;

  documentation.dev.enable = true;
  # documentation.man.generateCaches = true;

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

      # doc
      man-pages
      man-pages-posix
    ];
}
