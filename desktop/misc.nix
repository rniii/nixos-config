{ pkgs, ... }:

{
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        pulse.enable = true;
        jack.enable = true;
    };

    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
            fcitx5-mozc-ut
        ];
    };

    fonts.fontconfig.defaultFonts = {
        monospace = [
            "Sarasa Term J"
            "Symbols Nerd Font"
        ];
    };

    fonts.packages = with pkgs; [
        liberation_ttf
        lmodern
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        sarasa-gothic

        nerd-fonts.symbols-only
    ];
}
