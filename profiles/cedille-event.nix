# Poste dédié : pull-through cache Nix pour le reste du parc (voir
# modules/binary-cache-proxy.nix). Installé via le même ISO/flow que
# lanets-default (menu install-menu.sh, layout disque identique), mais avec
# un profil logiciel minimal — pas de bureau KDE, juste de quoi administrer
# la machine et faire tourner nginx.
{ ... }: {
  imports = [
    ../modules/disk-layout.nix

    ../modules/console-utils.nix
    ../modules/user-cedille.nix
    ../modules/binary-cache-proxy.nix
    ../modules/kubernetes.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;

  # Hostname fixe : cette machine est identifiée par son rôle, pas par un
  # numéro de série (contrairement à modules/networking.nix utilisé par les
  # postes du parc).
  networking.hostName = "event-02";

  system.stateVersion = "26.05";
  
  services.cedille-demo = {
    enable = true;
    role = "agent";
  };
}

