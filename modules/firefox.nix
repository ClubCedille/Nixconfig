# modules/firefox.nix
{ pkgs, ... }: {

  programs.firefox = {
    enable = true;
    
    # Configuration des politiques d'entreprise globales (immuables pour l'utilisateur)
    policies = {
      # Désactiver le premier lancement et les trucs intrusifs
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisplayBookmarksBar = "always"; # Pratique pour les raccourcis du LAN

      # Nettoyage de la page d'accueil par défaut
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
        TopSites = false;
        Highlights = false;
      };

      # Forcer des extensions indispensables (uBlock Origin)
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };

      # Pré-configuration des préférences du moteur (About:config)
      Preferences = {
        "browser.search.suggest.enabled" = false;
        "browser.startup.homepage" = "https://www.google.com";
      };
    };
  };
}