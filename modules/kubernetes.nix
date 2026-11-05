{config, lib, pkgs, }:

with lib;

let
	cfg = config.services.cedille-demo;
in {
	options.services.cedille-demo = {
		enable = mkEnableOption "Configuration du cluster Kubernetes";

		role = mkOption {
			type = types.enum [ "server" "agent"]];
			default = "agent";
			description = "Role dans le cluster: 'server' (Master) 'agent'(Worker)";

			};

			serverAddr = mkOption {
				type = types.nullOr types.str;
				default = null;
				description = "Adresse IP du serveur Master";

			};

			tokenFile = mkOption {
			type = types.path;
			default = "/var/lib/k3s-token";
			description = "path vers le fichier contenant le token secret du cluster";
			};
		};


		config = mkIf cfg.enable {
    		# Outils d'administration système installés partout
    		environment.systemPackages = [ pkgs.kubectl ];

    		services.k3s = {
      			enable = true;
      			role = cfg.role;
      			tokenFile = cfg.tokenFile;
      			# Seuls les agents ont besoin de l'adresse du serveur
      			serverUrl = if cfg.role == "agent" then "https://${cfg.serverAddr}:6443" else "";
    		};

    		# Ouverture des ports nécessaires dans le pare-feu NixOS
    		networking.firewall = {
      			allowedTCPPorts = if cfg.role == "server" 
        		then [ 6443 2379 2380 10250 ] # API Server, Etcd, Kubelet
        		else [ 10250 ];               # Kubelet
      
      			allowedUDPPorts = [ 8472 ];     # Requis pour le réseau Flannel VXLAN
    		};
  	};
}


