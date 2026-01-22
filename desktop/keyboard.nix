{ pkgs, ... }:

let
  xkb-patched =
    pkgs.xorg.xkeyboardconfig.overrideAttrs
      { postPatch = ''
        cat >>keycodes/thinkpad <<EOF
        partial xkb_keycodes "abnt_fix" {
          alias <RCTL> = <AB11>;
        };
        EOF

        ${pkgs.ed}/bin/ed -v rules/base.xml <<EOF
        /<description>Compatibility options
        /<\/group>
        -
        a
        <option>
          <configItem>
            <name>thinkpad:abnt_fix</name>
            <description>Fix the ABNT Thinkpad layout having a key detected as Right Control</description>
          </configItem>
        </option>
        .
        w
        EOF
        '';
      };
in
{
  environment.sessionVariables = { XKB_CONFIG_ROOT = "${xkb-patched}/etc/X11/xkb"; };
}
