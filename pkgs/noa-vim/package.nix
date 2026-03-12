{ buildVimPlugin, fetchFromGitHub }:

buildVimPlugin
  { pname   = "noa";
    version = "0-unstable-2026-03-04";

    src = fetchFromGitHub
      { owner = "rniii";
        repo  = "noa";
        rev   = "cfd60b5a8f99725d5597168dab5aa7b976fc849f";
        hash  = "sha256-FovrSJdVUydOZ04rYpqs4Xkvvv3199NeXTrRvoJfA4M=";
      };
  }
