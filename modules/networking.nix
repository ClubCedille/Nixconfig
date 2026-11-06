# modules/networking.nix
{ config, pkgs, ... }:

{
  networking = {
    hostName = "event-02"; # ou worker1 / worker2

    # Garde le comportement DHCP global pour l'accès Internet
    useDHCP = true;

    # Configuration de la carte Ethernet avec l'IP secondaire
    interfaces.eno1 = { # <-- Remplacez "enp3s0" par votre vrai nom d'interface
      useDHCP = true;
      ipv4.addresses = [{
        address = "192.168.100.2"; # Mettre .2 et .3 sur les workers
        prefixLength = 24;
      }];
    };

    # Autoriser la communication locale du cluster k3s
    firewall = {
      enable = true;
      extraCommands = ''
        iptables -A nixos-fw -s 192.168.100.0/24 -j ACCEPT
      '';
    };
  };
}
