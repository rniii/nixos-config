{
  neovim-unwrapped,
  vimPlugins,
  wrapNeovimUnstable,
}:

wrapNeovimUnstable neovim-unwrapped
  { luaRcContent = ''
    require("nvim-treesitter.configs").setup
      { highlight = { enable = true }
      , autotag   = { enable = true }
      , indent    = { enable = true }
      }
    '';
    plugins = with vimPlugins;
      [ (nvim-treesitter.withPlugins (import ./grammar-list.nix))
      ];
  }
