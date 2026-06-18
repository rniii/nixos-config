{ pkgs, ... }:

{
  documentation.dev.enable = true;

  programs.mosh.enable = true;
  programs.nano.enable = false;
  programs.neovim.enable = true;

  environment.systemPackages = with pkgs;
    [ # devel
      git
      nodejs pnpm esbuild
      python3
      stdenv clang clang-tools meson ninja
      # erlang rebar3
      ghc stack
      gdb lldb

      # nixing
      npins

      # sysadmin
      dig
      ed
      inetutils
      nmap
      p7zip
      sqlite-interactive
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
      patchelf
      radare2
      strace

      # doc
      man-pages
      man-pages-posix
    ];
}
