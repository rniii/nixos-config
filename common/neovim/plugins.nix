{ config, lib, pkgs, ... }:

let
    cfg = config.programs.neovim;

    utils = pkgs.callPackage ./utils.nix {};

    inherit (utils) mkPlugin;

    nvim-treesitter-wrapped = with pkgs.vimPlugins;
        nvim-treesitter.withPlugins (import ./grammar-list.nix);

    neov-ime-nvim = pkgs.callPackage
        ../../pkgs/neov-ime-nvim/package.nix
        { };

    twoslash-queries-nvim = pkgs.callPackage
        ../../pkgs/twoslash-queries-nvim/package.nix
        { };
in (
    lib.mkMerge [
        {
            programs.neovim.plugins = with pkgs.vimPlugins; [
                (mkPlugin fidget-nvim "fidget" {
                    notification.window.blend = 0;
                    progress.display.progress_icon = [ "noise" ];
                })
                (mkPlugin mini-icons {})
                (mkPlugin oil-nvim "oil" {} ./oil-nvim.lua)
                (mkPlugin oil-git-status-nvim "oil-git-status" {})
                gitsigns-nvim
                vim-illuminate

                (mkPlugin nvim-treesitter-wrapped ./nvim-treesitter.lua)
                (mkPlugin nvim-highlight-colors { })
                (mkPlugin vim-polyglot ./vim-polyglot.lua)

                (mkPlugin better-escape-nvim "better_escape" {})
                (mkPlugin neov-ime-nvim ./neov-ime.lua)
                (mkPlugin nvim-autopairs {})
                (mkPlugin nvim-ts-autotag {})
                (mkPlugin scope-nvim "scope" {})
                (mkPlugin ts-comments-nvim "ts-comments" {})
                (mkPlugin vim-qf ./vim-qf.lua)
                vim-commentary
                vim-easy-align
                vim-endwise
                vim-fugitive
                vim-ragtag
                vim-repeat
                vim-rsi
                vim-sleuth
                vim-surround
            ];
        }
        (lib.mkIf cfg.enableLspPlugins {
            programs.neovim.plugins = with pkgs.vimPlugins; [
                (mkPlugin SchemaStore-nvim ./schemastore-nvim.lua)
                (mkPlugin twoslash-queries-nvim ./twoslash-queries-nvim.lua)
                (mkPlugin blink-cmp {
                    keymap.preset = "super-tab";
                    signature.enabled = true;
                })
            ];
        })
    ]
)

# vim: sw=4:
