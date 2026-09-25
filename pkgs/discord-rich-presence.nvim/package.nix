{ vimUtils, fetchzip }:

vimUtils.buildVimPlugin {
    pname = "discord-rich-presence.nvim";
    version = "0-unstable-2026-09-14";
    src = fetchzip {
        url = "https://tangled.org/did:plc:grra5dushloek2lntg5pqsav/archive/5d4ea91516feab12a3bf277bebdd898ee67c7504.tar.gz";
        hash = "sha256-191q7QMuhS7JxD94PySwtW616VhmG/mNGiZpOlx6AZg=";
    };

    doCheck = false;
}

# vim: sw=4:
