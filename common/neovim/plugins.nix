{ config, lib, pkgs, inputs, ... }:

let
    cfg = config.programs.neovim;

    inherit (pkgs.callPackage ./utils.nix {})
        mkPlugin;

    inherit (inputs.self.packages.${pkgs.stdenv.system})
        discord-rich-presence-nvim
        neov-ime-nvim
        twoslash-queries-nvim;

    nvim-treesitter-wrapped = with pkgs.vimPlugins;
        nvim-treesitter.withPlugins (import ./grammar-list.nix);
in (
    lib.mkMerge [
        {
            programs.neovim.plugins = with pkgs.vimPlugins; [
                (mkPlugin fidget-nvim "fidget" {
                    notification.window.blend = 0;
                    progress.display.progress_icon = [ "noise" ];
                })
                (mkPlugin mini-icons { file = {
                    "README.md".glyph = "󰍔";
                    "README.md".hl = "MiniIconsGrey";
                    "README.txt".glyph = "󰦪";
                    "README.txt".hl = "MiniIconsYellow";
                }; })
                (mkPlugin oil-nvim "oil" { win_options = {
                    signcolumn = "yes:2";
                    number = false;
                    relativenumber = false;
                }; } ./oil-nvim.lua)
                (mkPlugin oil-git-status-nvim "oil-git-status" {})
                gitsigns-nvim
                vim-illuminate

                (mkPlugin nvim-treesitter-wrapped ./nvim-treesitter.lua)
                (mkPlugin nvim-highlight-colors {})
                (mkPlugin vim-polyglot ./vim-polyglot.lua)

                (mkPlugin neov-ime-nvim ./neov-ime.lua)
                (mkPlugin nvim-autopairs {})
                (mkPlugin nvim-ts-autotag {})
                (mkPlugin scope-nvim "scope" {})
                (mkPlugin vim-easy-align ./vim-easy-align.lua)
                (mkPlugin vim-qf ./vim-qf.lua)
                discord-rich-presence-nvim
                vim-commentary
                vim-endwise
                vim-fugitive
                vim-repeat
                vim-rsi
                vim-sleuth
                vim-surround
                vim-unimpaired
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
