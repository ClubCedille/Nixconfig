# profiles/cedille-ws.nix
{ inputs, ... }: {
  imports = [
    # 1. Importer le module disko fourni par les inputs du flake
    inputs.disko.nixosModules.disko

    # 2. Importer le layout de disque choisi pour ce profil
    ../disko/common-single-disk.nix

    # 3. Importer les composants logiciels du profil
    ../modules/console-utils.nix
    ../modules/starship.nix
    ../modules/vscode.nix
    ../modules/kde.nix
  ];

  # Configuration de base pour permettre le boot après disko-install
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lan-ets-xx";

  # Vos configurations spécifiques à Cédille ci-dessous...
  system.stateVersion = "26.05"; # À adapter selon votre canal NixOS
}
