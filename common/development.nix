{ pkgs, ... }:

{
    documentation.dev.enable = true;

    environment.systemPackages = with pkgs; [
        # Haskell
        ghc
        stack

        # JavaScript
        esbuild
        nodejs
        pnpm
        typescript

        # C
        clang
        clang-tools
        meson
        ninja
        pkg-config

        gdb
        lldb

        nasm

        # Other
        luajit
        python3
        ruby
    ];
}
