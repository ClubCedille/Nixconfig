{ config, pkgs, ... }:

{
  networking = {
    hostName = "event-01"; # ou master / worker

    # Désactiver le réseau scripté par défaut au profit de systemd-networkd
    useDHCP = false;
    useNetworkd = true;

    firewall = {
      enable = true;
      # Autoriser tout le trafic K3s entre les machines du sous-réseau privé
      extraCommands = ''
        iptables -A nixos-fw -s 192.168.100.0/24 -j ACCEPT
      '';
    };
  };

  # Configuration explicite de l'interface via systemd-networkd
  systemd.network.networks."10-eno1" = {
    matchConfig.Name = "eno1"; # Vérifiez le nom avec `ip -br link`
    networkConfig = {
      DHCP = "yes"; # Récupère l'IP + gateway de l'école
    };
    # IP statique dédiée au cluster K3s
    address = [
      "192.168.100.2/24"
    ];
  };
}
