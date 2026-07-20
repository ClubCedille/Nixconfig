{ ... }: {
  imports = [
    # 1. Layout disque (ESP + swap + root ext4), partitionné à la main par install-menu.sh
    ../modules/disk-layout.nix

    # 2. Importer les composants logiciels du profil
    ../modules/console-utils.nix
    ../modules/firefox.nix
    ../modules/kde.nix
    ../modules/networking.nix
    ../modules/nix-cache-client.nix
    ../modules/starship.nix
    ../modules/vscode.nix
    ../modules/user-lanets.nix
  ];

  # Configuration de base pour permettre le boot après l'installation
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;

  # Vos configurations spécifiques à Cédille ci-dessous...
  system.stateVersion = "26.05"; # À adapter selon votre canal NixOS
}
