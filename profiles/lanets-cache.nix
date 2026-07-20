# Poste dédié : pull-through cache Nix pour le reste du parc (voir
# modules/binary-cache-proxy.nix). Installé via le même ISO/flow que
# lanets-default (menu install-menu.sh, layout disque identique), mais avec
# un profil logiciel minimal — pas de bureau KDE, juste de quoi administrer
# la machine et faire tourner nginx.
{ ... }: {
  imports = [
    ../modules/disk-layout.nix

    ../modules/console-utils.nix
    ../modules/user-lanets.nix
    ../modules/binary-cache-proxy.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;

  # Hostname fixe : cette machine est identifiée par son rôle, pas par un
  # numéro de série (contrairement à modules/networking.nix utilisé par les
  # postes du parc).
  networking.hostName = "lanets-cache";

  system.stateVersion = "26.05";
}
