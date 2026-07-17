# modules/kde.nix
{ pkgs, ... }: {

  # 1. Services Graphiques NixOS standard
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  time.timeZone = "America/Montreal";
  i18n.defaultLocale = "fr_CA.UTF-8";

  # 2. Paquets et Polices système requis
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    ghostty
    candy-icons
  ];

  # 3. Configurations Globales de l'environnement (XDG Defaults)
  # Tout utilisateur créé ou se connectant sur la machine héritera automatiquement de ces fichiers.
  environment.etc = {
    "xdg/kdeglobals".text = ''
      [General]
      TerminalApplication=${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true
      TerminalService=com.mitchellh.ghostty.desktop

      [KDE]
      AnimationDurationFactor=0
      widgetStyle=Breeze

      [Icons]
      Theme=candy-icons

      [WM]
      activeBackground=30,30,46
      inactiveBackground=30,30,46
      activeForeground=205,214,244
      inactiveForeground=186,194,222
    '';

    "xdg/kwinrc".text = ''
      [Desktops]
      Number=1
      Rows=1

      [Tiling]
      padding=4

      [Xwayland]
      Scale=1.35

      [ModifierOnlyShortcuts]
      Meta=org.kde.krunner,/App,org.kde.krunner.App,display
    '';

    "xdg/krunnerrc".text = ''
      [General]
      FreeFloating=true
      historyBehavior=ImmediateCompletion
    '';

    "xdg/plasma-localerc".text = ''
      [Formats]
      LANG=fr_CA.UTF-8
    '';

    "xdg/spectaclerc".text = ''
      [ImageSave]
      translatedScreenshotsFolder=Copies d'écran
      [VideoSave]
      translatedScreencastsFolder=Copies d'écran
    '';

    "xdg/baloofilerc".text = ''
      [General]
      dbVersion=2
    '';

    # Raccourcis globaux du système (remplace programs.plasma.shortcuts)
    "xdg/kglobalshortcutsrc".text = ''
      [ksmserver]
      Lock Session=Meta+L\tScreensaver,Meta+L\tScreensaver,Verrouiller la session
      Log Out=Ctrl+Alt+Del,Ctrl+Alt+Del,Afficher le menu de déconnexion

      [kwin]
      Walk Through Windows=Alt+Tab,,Parcourir les fenêtres
      Walk Through Windows (Reverse)=Alt+Shift+Tab,,Parcourir les fenêtres (ordre inverse)
      Window Close=Alt+F4,,Fermer la fenêtre
      Window Maximize=Meta+PgUp,,Maximiser la fenêtre
      Window Minimize=Meta+PgDown,,Minimiser la fenêtre
      Window Quick Tile Left=Meta+Left,,Mettre la fenêtre sur la moitié gauche
      Window Quick Tile Right=Meta+Right,,Mettre la fenêtre sur la moitié droite
      Window Quick Tile Top=Meta+Up,,Mettre la fenêtre sur la moitié haute
      Window Quick Tile Bottom=Meta+Down,,Mettre la fenêtre sur la moitié basse
      Overview=Meta+Tab,,Vue d'ensemble
      Grid View=Meta+Shift+Tab,,Vue en grille

      [plasmashell]
      activate application launcher=Alt+F1,,Activer le lanceur d'applications
      activate task manager entry 1=Meta+1,,Activer l'entrée 1 du gestionnaire de tâches
      activate task manager entry 2=Meta+2,,Activer l'entrée 2 du gestionnaire de tâches
      activate task manager entry 3=Meta+3,,Activer l'entrée 3 du gestionnaire de tâches

      [kmix]
      mute=Volume Mute,,Sourdine du volume
      increase_volume=Volume Up,,Augmenter le volume
      decrease_volume=Volume Down,,Diminuer le volume
    '';
  };
}