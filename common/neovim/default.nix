{ config, lib, pkgs, ... }:

let
    cfg = config.programs.neovim;

    inherit (lib.attrsets) mapAttrsToList;
    inherit (lib.lists)    concatMap filter;
    inherit (lib.strings)  concatLines;
    inherit (lib.trivial)  mapNullable;

    toLua = lib.generators.toLua { };

    configPlugin = pkgs.vimUtils.buildVimPlugin {
        name = "vim-config";
        src  = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
                ./colors/meow.lua
                ./lua/ui.lua
                ./plugin/config.lua
            ];
        };
        doCheck = false;
    };

    genOpts = ns:
        mapAttrsToList (opt: val: "${ns}.${opt} = ${toLua val}");

    genPluginConfig =
        { main ? null, opts ? null, init ? null, ... }:

        assert opts != null -> main != null;

        filter (c: c != null) [
            (if builtins.isPath init then builtins.readFile init else init)
            (mapNullable (opts: "require(${toLua main}).setup ${toLua opts}") opts)
        ];

    genLspConfig =
        { server, enable ? server.pname, config ? {}, ... }:

        [ "vim.lsp.enable(${toLua enable})" ] ++
        mapAttrsToList (name: cfg: "vim.lsp.config(${toLua name}, ${toLua cfg})") config;
in {
    imports = [
        ./language-servers.nix
        ./options.nix
        ./plugins.nix
    ];

    options = {
        programs.neovim.enableLspPlugins = lib.mkEnableOption "lsp plugins";

        programs.neovim.plugins = lib.mkOption {
            type = with lib.types; listOf anything;
            default = [];
        };

        programs.neovim.languageServers = lib.mkOption {
            type = with lib.types; listOf anything;
            default = [];
        };

        programs.neovim.vimOptions = lib.mkOption {
            type = with lib.types; attrsOf json;
            default = {};
        };

        programs.neovim.vimGlobals = lib.mkOption {
            type = with lib.types; attrsOf json;
            default = {};
        };

        programs.neovim.extraLuaConfig = lib.mkOption {
            type = lib.types.lines;
            default = "";
        };
    };

    config = lib.mkMerge [
        {
            programs.neovim.configure = {
                customLuaRC = concatLines (
                    concatMap genPluginConfig (filter (p: p ? plug) cfg.plugins) ++
                    genOpts "vim.opt" cfg.vimOptions ++
                    genOpts "vim.g" cfg.vimGlobals ++
                    [ cfg.extraLuaConfig ]
                );
                packages.myVimPackage.start =
                    [ configPlugin ] ++
                    map (p: p.plug or p) cfg.plugins;
            };
        }
        (lib.mkIf (cfg.languageServers != []) {
            programs.neovim.plugins = with pkgs.vimPlugins; [ {
                plug = nvim-lspconfig.overrideAttrs {
                    passthru.runtimeDeps = map (c: c.server or c) cfg.languageServers;
                };
                init = concatLines (concatMap genLspConfig cfg.languageServers);
            } ];
        })
    ];
}

# vim: sw=4:
