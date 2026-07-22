{
  callPackage,
  lib,
  neovim-unwrapped,
  pkgs,
  vimPlugins,
  vimUtils,
  wrapNeovimUnstable,
}:

let
  inherit (lib)
    concatLines
    concatMap
    filter
    mapAttrsToList
    mapNullable
    ;

  toLua = lib.generators.toLua { };

  pluginConfig = with vimPlugins;
    [ # ui plugins
      noa-vim
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

  syntaxPlugins = with vimPlugins;
    [ { plug = nvim-treesitter.withPlugins (import ./grammar-list.nix);
        config = ''
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

      # lsp
      (let
        runtimeDeps = with pkgs;
          [ ccls
            emmet-language-server
            # erlang-language-platform
            haskell-language-server
            nixd
            typescript-language-server
            vscode-langservers-extracted
            vue-language-server
            yaml-language-server
          ];

        lsps =
          [ "ccls"
            "emmet_language_server"
            # "elp"
            "hls"
            "nixd"
            "ts_ls"
            "cssls" "eslint" "html" "jsonls"
            "vue_ls"
            "yamlls"
          ];
      in
      { plug = nvim-lspconfig.overrideAttrs
          { passthru = { inherit runtimeDeps; }; };
        config = ''
          vim.lsp.enable ${toLua lsps}

          vim.lsp.config("eslint", { settings = {
            rulesCustomizations = {
              { rule = "@stylistic/*", severity = "off", fixable = true },
            },
          } })

          vim.lsp.config("hls", {
            filetypes = { "haskell", "lhaskell", "cabal" },
          })

          vim.lsp.config('ts_ls', {
            init_options = {
              plugins = { {
                name = '@vue/typescript-plugin',
                location = ${
                  toLua "${pkgs.vue-language-server}/lib/language-tools/packages/language-server"
                },
                languages = { 'vue' },
                configNamespace = 'typescript',
              } },
            },
            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
          })
        '';
      })
      { plug = SchemaStore-nvim;
        config = ''
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
        config = ''
          vim.lsp.config("ts_ls", { on_attach = function(client, bufnr)
            require("twoslash-queries").attach(client, bufnr)
          end })
        '';
      }

      # completion
      { plug = blink-cmp;
        opts.keymap.preset = "super-tab";
        opts.signature.enabled = true;
      }

      # editing
      { plug = nvim-autopairs;
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
        config = ''
          vim.g.qf_loclist_window_bottom = 0
        '';
      }
      vim-ragtag
      vim-repeat
      vim-rsi
      vim-sleuth
      vim-surround

      # language support
      { plug = vim-polyglot;
        config = ''
          vim.g.haskell_indent_case_alternative = 1
        '';
      }
    ];

  noa-vim = callPackage ../noa-vim/package.nix
    { inherit (vimUtils) buildVimPlugin;
    };

  twoslash-queries-nvim = callPackage ../twoslash-queries-nvim/package.nix
    { inherit (vimUtils) buildVimPlugin;
    };

  vimOptions =
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

  genOpts = ns:
    mapAttrsToList (opt: val: "${ns}.${opt} = ${toLua val}");

  genPluginConfig =
    { plug, main ? plug.pname, opts ? null, config ? null }:
    filter (c: c != null)
      [ config
        (mapNullable (opts: "require(${toLua main}).setup ${toLua opts}") opts)
      ];
in
wrapNeovimUnstable neovim-unwrapped
  { luaRcContent = concatLines
      ( concatMap genPluginConfig (filter (p: p ? plug) pluginConfig)
          ++ genOpts "vim.opt" vimOptions
      );

    plugins = map (p: p.plug or p) pluginConfig;
  }
