{ pkgs, ... }:

{
  documentation.dev.enable = true;

  programs.mosh.enable = true;
  programs.nano.enable = false;
  programs.neovim.enable = true;

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
      vim

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
