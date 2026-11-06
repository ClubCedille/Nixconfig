{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cedille-demo;
  
  # Utiliser l'IP statique du master sur le réseau privé dédié
  masterIP = "192.168.100.1"; 
in {
  options.services.cedille-demo = {
    enable = mkEnableOption "Service Kubernetes Cedille-Demo";
    
    role = mkOption {
      type = types.enum [ "server" "agent" ];
      default = "agent";
      description = "Rôle de la machine : 'server' (master) ou 'agent' (worker)";
    };

    # Optionnel mais recommandé : permettre de spécifier l'IP locale du nœud
    nodeIP = mkOption {
      type = types.str;
      default = "192.168.100.1";
      description = "IP statique de la machine dans le cluster (ex: 192.168.100.1, .2, .3)";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kubectl ];

    services.k3s = {
      enable = true;
      role = cfg.role;
      
      serverAddr = if cfg.role == "agent" then "https://${masterIP}:6443" else "";
      tokenFile = "/var/lib/k3s-token";

      # Forcer K3s et Flannel sur le réseau privé 192.168.100.0/24
      extraFlags = toString [
        "--node-ip=${cfg.nodeIP}"
        "--flannel-iface=eno1" 
        (if cfg.role == "server" then "--advertise-address=${masterIP} --tls-san=${masterIP}" else "")
      ];
    };

    networking.firewall = {
      allowedTCPPorts = if cfg.role == "server"
        then [ 6443 2379 2380 10250 ]
        else [ 10250 ];
        
      allowedUDPPorts = [ 8472 ];
    };
  };
}

