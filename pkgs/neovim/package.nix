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
      # { plug = nvim-origami;
      #   main = "origami";
      #   opts.autoFold = { enabled = true; kinds = [ "imports" ]; };
      #   opts.foldKeymaps.closeOnlyOnFirstColumn = true;
      #   config = ''
      #     vim.o.foldlevel = 99
      #     vim.o.foldlevelstart = 99
      #   '';
      # }
      vim-dirvish

      # highlighting
      { plug = nvim-treesitter.withPlugins (import ./grammar-list.nix);
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
      vim-illuminate

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
          ];

        lsps =
          [ "ccls"
            "emmet_language_server"
            # "elp"
            "hls"
            "nixd"
            "ts_ls"
            "cssls" "eslint" "html" "jsonls"
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
        '';
      })
      { plug = SchemaStore-nvim;
        config = ''
          vim.lsp.config("jsonls", { settings = { json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
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
      # { plug = mini-pairs;
      #   opts.modes.command = true;
      # }
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
      vim-polyglot
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
