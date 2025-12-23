{ pkgs, ... }:

let
  krohnkite-overlay = (final: prev:
    { kdePackages = prev.kdePackages.overrideScope (kfinal: kprev:
      { krohnkite = kprev.krohnkite.overrideAttrs
        { prePatch = ''
            # "TODO: configurable step size?" yes,configurable
            sed -i 's/const \(\wStepSize\) = \.*/const \1 = 10;/' src/engine/engine.ts
          '';
        };
      });
    });
in {
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  environment.plasma6.excludePackages =
    with pkgs.kdePackages; [ plasma-browser-integration kwin-x11 ];

  environment.systemPackages =
    with pkgs.kdePackages; [ krohnkite ];

  nixpkgs.overlays =
    [ krohnkite-overlay
    ];
}
