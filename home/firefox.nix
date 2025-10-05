{ config, pkgs, lib, ... }:
{
  # Let's setup Firefox
  programs.firefox = {
    enable = true;

    # Specify the language packs for Firefox
    languagePacks = [ "en-US" ];

    # Disable telemetry to prevent data collection
    policies = {
      DisableTelemetry = true;
      HardwareAcceleration = true;
      OfferToSaveLogins = false;
      DisableFirefoxStudies         = true;
      DisableFirefoxAccounts        = true;
      DisableFirefoxScreenshots     = true;
      DisplayMenuBar = "always";
    };

    # Configure the default profile settings
    profiles.default = {
      # Set default search engine to DuckDuckGo
      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
      };
    };
  };
}
