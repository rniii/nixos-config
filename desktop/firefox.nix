{ pkgs, ... }:

{
  programs.firefox =
    { enable  = true;
      package = pkgs.firefox-devedition;
      autoConfig = ''
        pref("datareporting.healthreport.uploadEnabled", false);
        pref("browser.ctrlTab.sortByRecentlyUsed", true);
        pref("full-screen-api.ignore-widgets", true);
        pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
      '';
      preferences =
        { "browser.aboutConfig.showWarning" = false;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          # newtab sponsor stuff
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";
          # tracking protection
          "browser.contentblocking.category" = "strict";
          # give firefox some amnesia
          "browser.privatebrowsing.autostart" = true;
        };
      policies =
        { SearchEngines.Remove = [ "Google" "Bing" ];
          GenerativeAI.Chatbot = false;
          GenerativeAI.LinkPreviews = false;
        };
    };
}
