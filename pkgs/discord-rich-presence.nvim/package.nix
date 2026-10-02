{ vimUtils, fetchzip }:

vimUtils.buildVimPlugin {
    pname = "discord-rich-presence.nvim";
    version = "0-unstable-2026-09-14";
    src = fetchzip {
        url = "https://tangled.org/did:plc:grra5dushloek2lntg5pqsav/archive/fd88888efeb386c72e20e6397c44105dbedb27c0.tar.gz";
        hash = "sha256-wvw9RJKEPFFx+lSDQ5bB+RMtIKEwPwbNYC5y6g6eLDs=";
    };

    doCheck = false;
}
