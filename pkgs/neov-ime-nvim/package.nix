{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin
  { pname   = "neov-ime.nvim";
    version = "0-unstable-2026-05-29";

    src = fetchFromGitHub
      { owner = "sevenc-nanashi";
        repo  = "neov-ime.nvim";
        rev   = "9d1dd789761fb3aadf91cdfed0cebcb750424380";
        hash  = "sha256-WtzKmhxhVupRRVe0fUyjV3js+WIVGU+8glg/mHHNeQ8=";
      };

    postPatch = ''
      sed -i '1 s/\*neov-ime\* //' doc/neov-ime.txt
    '';
  }
