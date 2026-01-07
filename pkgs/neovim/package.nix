{
  lib,
  neovim-unwrapped,
  pkgs,
  vimPlugins,
  wrapNeovimUnstable,
}:

let
  inherit (lib)
    attrNames
    attrValues
    concatMap
    toList
    pipe
    ;
  toLua = lib.generators.toLua { };

  luaRc = ''
    require("nvim-web-devicons").setup
      { color_icons = false,
      }

    require("nvim-treesitter.configs").setup
      { highlight = { enable = true },
        autotag   = { enable = true },
        indent    = { enable = true },
      }
  '';

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
      typescript-language-server = "ts_ls";
      vscode-langservers-extracted =
        [ "cssls"
          "eslint"
          "html"
          "jsonls"
        ];

      # XXX: old lsp list
      # emmet_language_server
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
    lib.foldlAttrs (code: opt: val: code + ''
      ${ns}.${opt} = ${toLua val}
    '') "";
in
wrapNeovimUnstable neovim-unwrapped
  { wrapperArgs =
      concatMap
        (name: [ "--suffix" "PATH" ":" "${pkgs.${name}}/bin" ])
        (attrNames lspsByPackage);

    luaRcContent = luaRc
    + genOpts "vim.opt" vimOptions
    + genOpts "vim.g" vimGlobals
    + ''
      vim.lsp.enable ${pipe lspsByPackage
        [ attrValues
          (concatMap toList)
          toLua
        ]}
    '';

    plugins = with vimPlugins;
      [ # ui plugins
        dropbar-nvim
        fidget-nvim
        gitsigns-nvim
        lualine-nvim
        nvim-origami
        nvim-web-devicons
        satellite-nvim
        telescope-nvim
        vim-dirvish

        # highlighting
        (nvim-treesitter.withPlugins (import ./grammar-list.nix))
        nvim-highlight-colors
        # vim-polyglot

        # lsp
        nvim-lspconfig
        SchemaStore-nvim
        # todo: twoslash

        # editing
        # nvim-autopairs
        # nvim-ts-autotag
        vim-commentary
        vim-easy-align
        vim-fugitive
        vim-repeat
        vim-rsi
        vim-sleuth
        vim-surround
      ];
  }
