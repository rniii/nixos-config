{ lib, pkgs, ... }:

let
    utils = pkgs.callPackage ./utils.nix {};

    inherit (utils) mkPlugin;

    nvim-treesitter-wrapped = with pkgs.vimPlugins;
        nvim-treesitter.withPlugins (import ./grammar-list.nix);

    neov-ime-nvim = pkgs.callPackage
        ../../pkgs/neov-ime-nvim/package.nix
        { };
in (
    lib.mkMerge [
        {
            programs.neovim.plugins = with pkgs.vimPlugins; [
                (mkPlugin fidget-nvim "fidget" {
                    notification.window.blend = 0;
                    progress.display.progress_icon = [ "noise" ];
                })
                gitsigns-nvim
                (mkPlugin mini-icons {})
                vim-dirvish
                vim-illuminate
            ];
        }
        {
            programs.neovim.plugins = with pkgs.vimPlugins; [
                (mkPlugin nvim-treesitter-wrapped ./nvim-treesitter.lua)
                (mkPlugin nvim-highlight-colors { })
                (mkPlugin vim-polyglot ./vim-polyglot.lua)
            ];
        }
        {
            programs.neovim.plugins = with pkgs.vimPlugins; [
                (mkPlugin nvim-autopairs { })
                (mkPlugin nvim-ts-autotag { })
                (mkPlugin scope-nvim "scope" { })
                (mkPlugin neov-ime-nvim ./neov-ime.lua)
                vim-commentary
                vim-easy-align
                vim-endwise
                vim-fugitive
                (mkPlugin vim-qf ./vim-qf.lua)
                vim-ragtag
                vim-repeat
                vim-rsi
                vim-sleuth
                vim-surround
            ];
        }
    ]
)

# vim: sw=4:
