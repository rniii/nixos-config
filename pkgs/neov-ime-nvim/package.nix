{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin
  { pname   = "neov-ime.nvim";
    version = "0-unstable-2026-05-29";

    src = fetchFromGitHub
      { owner = "sevenc-nanashi";
        repo  = "neov-ime.nvim";
        rev   = "d4e030486d446419d836b1daa954cd1fbcb6a75e";
        hash  = "sha256-Z9544Yb3cXSzmxLERvq3bAFBGi7nYIQfNYygrDL0R9w=";
      };
  }
