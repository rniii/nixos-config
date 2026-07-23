{ config, lib, pkgs, ... }:

let
  cfg = config.programs.neovim;

  inherit (lib)
    concatLines
    concatMap
    filter
    mapAttrsToList
    mapNullable
    ;

  toLua = lib.generators.toLua { };

  # XXX: remove these things from toplevel later
  uiPlugins = with pkgs.vimPlugins;
    [ base16-nvim
      { plug = fidget-nvim;
        main = "fidget";
        opts.progress.display.progress_icon = [ "noise" ];
      }
      gitsigns-nvim
      { plug = mini-icons;
        opts = { };
      }
      vim-dirvish
      vim-illuminate
    ];

  syntaxPlugins = with pkgs.vimPlugins;
    [ { plug = nvim-treesitter.withPlugins (import ./grammar-list.nix);
        init = ''
          vim.api.nvim_create_autocmd("FileType", { pattern = "*", callback = function()
            local lang = vim.treesitter.language.get_lang(vim.bo.filetype)

            if vim.treesitter.query.get(lang, "highlights") then
              vim.treesitter.start()
              if vim.treesitter.query.get(lang, "indents") then
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
              end
            end
          end })
        '';
      }
      { plug = nvim-highlight-colors;
        opts = { };
      }
      { plug = vim-polyglot;
        init = ''
          vim.g.haskell_indent_case_alternative = 1
        '';
      }
    ];

  genericPlugins = with pkgs.vimPlugins;
    [ { plug = nvim-autopairs;
        opts = {};
      }
      { plug = nvim-ts-autotag;
        opts = {};
      }
      vim-commentary
      vim-easy-align
      vim-endwise
      vim-fugitive
      { plug = vim-qf;
        init = ''
          vim.g.qf_loclist_window_bottom = 0
        '';
      }
      vim-ragtag
      vim-repeat
      vim-rsi
      vim-sleuth
      vim-surround
    ];

  languageServers = with pkgs;
    [ { server = ccls; }
      { server = emmet-language-server;
        enable = "emmet_language_server";
      }
      { server = haskell-language-server;
        enable = "hls";

        config.hls.filetypes = [ "haskell" "lhaskell" "cabal" ];
      }
      { server = nixd; }
      { server = typescript-language-server;
        enable = "ts_ls";
      }
      { server = vscode-langservers-extracted;
        enable = [ "cssls" "eslint" "html" "jsonls" ];

        config.eslint.settings = {
          rulesCustomizations = [
            { rule = "@stylistic/*"; severity = "off"; fixable = true; }
          ];
        };
      }
      { server = vue-language-server;
        enable = "vue_ls";

        config.ts_ls.init_options = [ {
          plugins = [ {
            name = "@vue/typescript-plugin";
            location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
            languages = [ "vue" ];
            configNamespace = "typescript";
          } ];
        } ];
      }
      { server = yaml-language-server;
        enable = "yamlls";
      }
    ];

  lspPlugins = with pkgs.vimPlugins;
    [ { plug = nvim-lspconfig.overrideAttrs {
          passthru.runtimeDeps = map (c: c.server or c) languageServers;
        };
        init = concatLines (concatMap genLspConfig languageServers);
      }
      { plug = SchemaStore-nvim;
        init = ''
          vim.lsp.config("jsonls", { settings = { json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          } } })

          vim.lsp.config("yamlls", { settings = { yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          } } })
        '';
      }
      { plug = twoslash-queries-nvim;
        init = ''
          vim.lsp.config("ts_ls", { on_attach = function(client, bufnr)
            require("twoslash-queries").attach(client, bufnr)
          end })
        '';
      }
      # XXX: maybe not here
      { plug = blink-cmp;
        opts.keymap.preset = "super-tab";
        opts.signature.enabled = true;
      }
    ];

  configPlugin = pkgs.vimUtils.buildVimPlugin
    { name = "vim-config";
      src  = lib.fileset.toSource
        { root = ./.;
          fileset = lib.fileset.unions
            [ ./colors/meow.lua
              ./lua/ui.lua
              ./plugin/config.lua
            ];
        };
      doCheck = false;
    };

  defaultPlugins =
    uiPlugins ++
    syntaxPlugins ++
    genericPlugins;

  twoslash-queries-nvim = pkgs.callPackage
    ../../pkgs/twoslash-queries-nvim/package.nix
    { };

  genOpts = ns:
    mapAttrsToList (opt: val: "${ns}.${opt} = ${toLua val}");

  genPluginConfig =
    { plug, main ? plug.pname, opts ? null, init ? null }:
    filter (c: c != null)
      [ init
        (mapNullable (opts: "require(${toLua main}).setup ${toLua opts}") opts)
      ];

  genLspConfig =
    { server, enable ? server.pname, config ? {} }:
    [ "vim.lsp.enable(${toLua enable})" ] ++
    mapAttrsToList (name: cfg: "vim.lsp.config(${toLua name}, ${toLua cfg})") config;
in

{
  options = {
    programs.neovim.enableLspPlugins = lib.mkEnableOption "lsp plugins";

    programs.neovim.plugins = lib.mkOption {
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

  config = lib.mkMerge
    [
      {
        programs.neovim.configure = {
          customLuaRC = concatLines
            ( concatMap genPluginConfig (filter (p: p ? plug) cfg.plugins)
              ++ genOpts "vim.opt" cfg.vimOptions
              ++ genOpts "vim.g" cfg.vimGlobals
              ++ [ cfg.extraLuaConfig ]
            );
          packages.myVimPackage.start =
            [ configPlugin ]
            ++ map (p: p.plug or p) cfg.plugins;
        };
      }
      {
        programs.neovim.vimOptions =
          { number = true;
            relativenumber = true;
            signcolumn = "yes";
            cursorline = true;
            list = true;
            listchars =
              { extends = ">";
                precedes = "<";
                tab = "  ";
                trail = "•";
              };

            smartcase = true;
            ignorecase = true;

            undofile = true;
          };

        programs.neovim.plugins = defaultPlugins;
      }
      (lib.mkIf cfg.enableLspPlugins {
        programs.neovim.plugins = lspPlugins;
      })
    ];
}
