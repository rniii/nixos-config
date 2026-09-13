{ config, lib, pkgs, ... }:

let
    cfg = config.programs.neovim;

    utils = pkgs.callPackage ./utils.nix {};

    inherit (utils) mkServer;
in (
    lib.mkIf cfg.enableLspPlugins {
        programs.neovim.languageServers = with pkgs; [
            (mkServer ccls)
            (mkServer emmet-language-server "emmet_language_server")
            (mkServer haskell-language-server "hls" {
                hls.filetypes = [ "haskell" "lhaskell" "cabal" ];
            })
            (mkServer nixd)
            (mkServer typescript-language-server "ts_ls")
            (mkServer vscode-langservers-extracted [ "cssls" "eslint" "html" "jsonls" ] {
                eslint.settings.rulesCustomizations = [
                    { rule = "@stylistic/*"; severity = "off"; fixable = true; }
                ];
            })
            (mkServer vue-language-server "vue_ls" {
                ts_ls.init_options = [ {
                    plugins = [ {
                        name = "@vue/typescript-plugin";
                        location = "${vue-language-server}/lib/language-tools/packages/language-server";
                        languages = [ "vue" ];
                        configNamespace = "typescript";
                    } ];
                } ];
            })
            (mkServer yaml-language-server "yamlls")
        ];
    }
)

# vim: sw=4:
