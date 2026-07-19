{ inputs, ... }: {
  imports = [
    # 1. Layout disque (ESP + swap + ZFS), partitionné à la main par install-menu.sh
    ../modules/disk-layout.nix

    # 2. Importer les composants logiciels du profil
    ../modules/console-utils.nix
    ../modules/kde.nix
    ../modules/networking.nix
    ../modules/starship.nix
    ../modules/vscode.nix
    ../modules/zfs.nix
  ];

  # Configuration de base pour permettre le boot après l'installation
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;

  # Vos configurations spécifiques à Cédille ci-dessous...
  system.stateVersion = "26.05"; # À adapter selon votre canal NixOS
}
