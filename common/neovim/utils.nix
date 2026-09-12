{ lib }:

let
    inherit (lib.lists) foldr;

    uncurryProperty' = p: y: { __functor = self: x: self // { ${p} = x; } // y; };
    uncurryProperties = foldr uncurryProperty' {};

    # mkPlugin plug                 == mkPlugin plug null null null
    # mkPlugin plug { }             == mkPlugin plug null { } null
    # mkPlugin plug ./init.lua      == mkPlugin plug null null ./init.lua
    # mkPlugin plug { } ./init.lua  == mkPlugin plug null { } ./init.lua
    # mkPlugin plug "main" { }      == mkPlugin plug "main" { } null
    # mkPlugin plug "main" { } ./init.lua
    mkPlugin = plug: {
        inherit plug;
        __functor = self: main:
            let
                mkPlugin' = self // uncurryProperties [ "main" "opts" "init" ];
            in
            if builtins.isPath main then
                mkPlugin' null null main
            else if builtins.isAttrs main then
                mkPlugin' null main
            else opts:
                mkPlugin' main opts;
    };

    # mkServer server               == mkServer server null null
    # mkServer server "enable"      == mkServer server "enable" null
    # mkServer server "enable" { }
    mkServer = server: uncurryProperties [ "server" "enable" "config" ] server;
in {
    inherit mkPlugin mkServer;
}

# vim: sw=4:
