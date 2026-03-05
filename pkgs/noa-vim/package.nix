{ buildVimPlugin, fetchFromGitHub }:

buildVimPlugin
  { pname   = "noa";
    version = "0-unstable-2026-03-04";

    src = fetchFromGitHub
      { owner = "rniii";
        repo  = "noa";
        rev   = "1f2362f5d30e97c9f2c67871233c3f7fd2e33cf0";
        hash  = "sha256-XkptG4x2fW9WwfL6AEbbpvqIuvW24WLKBH3cVJu5Av8=";
      };
  }
