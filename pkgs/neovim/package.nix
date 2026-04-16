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
    attrNames
    attrValues
    attrVals
    concatLines
    concatMap
    filter
    mapAttrsToList
    mapNullable
    pipe
    toList
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
      { plug = nvim-origami;
        main = "origami";
        opts.autoFold = { enabled = true; kinds = [ "imports" ]; };
        opts.foldKeymaps.closeOnlyOnFirstColumn = true;
        config = ''
          vim.o.foldlevel = 99
          vim.o.foldlevelstart = 99
        '';
      }
      { plug = quicker-nvim;
        main = "quicker";
        opts.keys = lib.mkLuaInline ''{
          { ">", function() require("quicker").expand() end },
          { "<", function() require("quicker").collapse() end },
        }'';

        config = ''
          local quicker = require("quicker")

          vim.diagnostic.handlers.qflist = {
            show = function(ns, bufnr, diagnostics, opts)
              local wid = vim.api.nvim_get_current_win()
              opts.qflist.open = opts.qflist.open or false

              vim.diagnostic.setqflist(opts.qflist)
              vim.api.nvim_set_current_win(wid)
              quicker.refresh()
            end,
            hide = function (ns, bufnr)
              vim.diagnostic.setqflist { open = false }
              quicker.refresh()
            end,
          }
        '';
      }
      vim-dirvish

      # highlighting
      { plug = nvim-treesitter.withPlugins (import ./grammar-list.nix);
        config = ''
          vim.api.nvim_create_autocmd("FileType", { pattern = "*", callback = function()
            local lang = vim.treesitter.language.get_lang(vim.bo.filetype)

            if vim.treesitter.query.get(lang, "highlights") then
              vim.treesitter.start()
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end })
        '';
      }
      { plug = nvim-highlight-colors;
        opts = { };
      }
      vim-illuminate

      # lsp
      { plug = nvim-lspconfig.overrideAttrs
          { passthru.runtimeDeps = attrVals (attrNames lspsByPackage) pkgs;
          };
        config = ''
            vim.lsp.enable ${pipe lspsByPackage
              [ attrValues
                (concatMap toList)
                toLua
              ]}

            vim.lsp.config("eslint", { settings = {
              rulesCustomizations = {
                { rule = "@stylistic/*", severity = "off", fixable = true },
              },
            } })
        '';
      }
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
        opts.cmdline.keymap.preset = "inherit";
        opts.cmdline.completion.menu.auto_show = true;
      }

      # editing
      { plug = mini-pairs;
        opts.modes.command = true;
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

  vimGlobals =
    { mapleader = ",";
    };

  lspsByPackage =
    { ccls = "ccls";
      emmet-language-server = "emmet_language_server";
      nixd = "nixd";
      typescript-language-server = "ts_ls";
      vscode-langservers-extracted =
        [ "cssls"
          "eslint"
          "html"
          "jsonls"
        ];

      # XXX: old lsp list
      # mesonlsp
      # gopls
      # hls
      # ocamllsp
      # rust_analyzer
      # zls
      # lua_ls
      # efm
      # pylsp
      # uiua
      # kotlin_lsp
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
          ++ genOpts "vim.g" vimGlobals
      );

    plugins = map (p: p.plug or p) pluginConfig;
  }
