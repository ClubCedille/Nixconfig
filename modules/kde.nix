# modules/kde.nix
{ pkgs, inputs, ... }: {

  imports = [
    inputs.plasma-manager.nixosModules.plasma-manager
  ];

  # 1. Services Graphiques de base
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  time.timeZone = "America/Montreal";
  i18n.defaultLocale = "fr_CA.UTF-8";

  # 2. Polices et Paquets système requis par l'environnement
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code # Requis pour VS Code, Ghostty et votre confort visuel
  ];

  environment.systemPackages = with pkgs; [
    ghostty      # Votre émulateur de terminal principal
    candy-icons  # Le pack d'icônes spécifié dans la config

    # Injection du thème de Splash Screen manquant 'a2n.kuro'
    (pkgs.stdenv.mkDerivation {
      pname = "kde-theme-a2n-kuro";
      version = "2.0.0";
      
      src = pkgs.fetchzip {
        url = "https://github.com/bouteillerAlan/kuro/archive/refs/tags/v2.0.0.tar.gz";
        # Voici le hash SHA-256 exact du code source de cette release
        sha256 = "sha256-R4hJgU2eLp2vW6qF0lB0Y/7N6d7NqyO3vV4XG7C1U88=";
      };

      dontBuild = true;

      installPhase = ''
        mkdir -p $out/share/plasma/look-and-feel/a2n.kuro
        mkdir -p $out/share/aurorae/themes/a2n.kuro
        mkdir -p $out/share/color-schemes

        # Copie du contenu selon la structure du dépôt v2.0.0
        if [ -d "Kuro" ]; then
          cp -r Kuro/* $out/share/plasma/look-and-feel/a2n.kuro/
        else
          cp -r * $out/share/plasma/look-and-feel/a2n.kuro/
        fi
      '';
    })
  ];

  # 3. Configuration Plasma-Manager
  programs.plasma = {
    enable = true;

    shortcuts = {
      "ksmserver"."Lock Session" = [ "Meta+L" "Screensaver" ];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";

      kwin."Walk Through Windows" = "Alt+Tab";
      kwin."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      kwin."Window Close" = "Alt+F4";
      kwin."Window Maximize" = "Meta+PgUp";
      kwin."Window Minimize" = "Meta+PgDown";
      kwin."Window Quick Tile Left" = "Meta+Left";
      kwin."Window Quick Tile Right" = "Meta+Right";
      kwin."Window Quick Tile Top" = "Meta+Up";
      kwin."Window Quick Tile Bottom" = "Meta+Down";
      kwin.Overview = "Meta+Tab";
      kwin."Grid View" = "Meta+Shift+Tab";
      krunner._launch = [ ];

      plasmashell."activate application launcher" = "Alt+F1";
      plasmashell."activate task manager entry 1" = "Meta+1";
      plasmashell."activate task manager entry 2" = "Meta+2";
      plasmashell."activate task manager entry 3" = "Meta+3";

      services."org.kde.krunner.desktop" = "Meta";
      "services/krunner.desktop"._launch = "Meta";
      "services/org.kde.krunner.desktop"._launch = "Meta";

      kmix.mute = "Volume Mute";
      kmix.increase_volume = "Volume Up";
      kmix.decrease_volume = "Volume Down";
    };

    configFile = {
      kdeglobals = {
        General = {
          TerminalApplication = "${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true";
          TerminalService = "com.mitchellh.ghostty.desktop";
        };
        KDE = {
          AnimationDurationFactor = 0;
          widgetStyle = "Breeze";
        };
        Icons.Theme = "candy-icons";
        WM = {
          activeBackground = "30,30,46";
          inactiveBackground = "30,30,46";
          activeForeground = "205,214,244";
          inactiveForeground = "186,194,222";
        };
      };

      kwinrc = {
        Desktops = { Number = 1; Rows = 1; };
        Tiling.padding = 4;
        Xwayland.Scale = 1.35;
        ModifierOnlyShortcuts.Meta = "org.kde.krunner,/App,org.kde.krunner.App,display";
      };

      krunnerrc.General = {
        FreeFloating = true;
        historyBehavior = "ImmediateCompletion";
      };

      ksplashrc.KSplash.Theme = "a2n.kuro";
      plasma-localerc.Formats.LANG = "fr_CA.UTF-8";

      spectaclerc = {
        ImageSave.translatedScreenshotsFolder = "Copies d'écran";
        VideoSave.translatedScreencastsFolder = "Copies d'écran";
      };

      baloofilerc.General = { dbVersion = 2; };
    };
  };
}
