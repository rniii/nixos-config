{ pkgs, ... }:

let
  xkb-patched =
    pkgs.xorg.xkeyboardconfig.overrideAttrs
      { postPatch = ''
        cat >>symbols/jp <<EOF

        partial alphanumeric_keys xkb_symbols "abnt2_thinkpad" {
          include "jp(common)"

          name[Group1]= "Japanese (ABNT2, IBM/Lenovo ThinkPad)";

          key <RCTL> {[ backslash, underscore ]};
        };
        EOF

        ${pkgs.ed}/bin/ed -v rules/base.xml <<EOF
        /<description>Japanese<\/description>
        /<\/variantList>
        -
        a
        <variant>
          <configItem>
            <name>abnt2_thinkpad</name>
            <description>Japanese (ABNT2, IBM/Lenovo ThinkPad)</description>
          </configItem>
        </variant>
        .
        w
        EOF
        '';
      };
in
{
  environment.sessionVariables = { XKB_CONFIG_ROOT = "${xkb-patched}/etc/X11/xkb"; };
}
