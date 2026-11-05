{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cedille-demo;
  
  
  masterIP = "10.214.96.83"; 
in {
  options.services.cedille-demo = {
    enable = mkEnableOption "Service Kubernetes Cedille-Demo";
    
    role = mkOption {
      type = types.enum [ "server" "agent" ];
      default = "agent";
      description = "Rôle de la machine : 'server' (master) ou 'agent' (worker)";
    };
  };

  config = mkIf cfg.enable {
    # Inclusion de kubectl pour administrer le cluster
    environment.systemPackages = [ pkgs.kubectl ];

    # Utilisation de K3s pour une gestion multi-nœuds simple et robuste
    services.k3s = {
      enable = true;
      role = cfg.role;
      
      # Si c'est un agent, on le pointe automatiquement vers le serveur maître
      serverAddr = if cfg.role == "agent" then "https://${masterIP}:6443" else "";
      
      # Chemin vers le token secret partagé entre les 3 machines
      tokenFile = "/var/lib/k3s-token";
    };

    # Ouverture stricte des ports requis par K3s pour communiquer à 3 machines
    networking.firewall = {
      allowedTCPPorts = if cfg.role == "server"
        then [ 6443 2379 2380 10250 ] # API Server, Etcd, Kubelet
        else [ 10250 ];               # Kubelet uniquement
        
      allowedUDPPorts = [ 8472 ];     # Requis pour Flannel VXLAN (réseau des Pods)
    };
  };
}


