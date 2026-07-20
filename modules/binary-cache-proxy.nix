# Pull-through cache pour cache.nixos.org : reverse-proxy nginx qui met en
# cache sur disque les .narinfo/.nar déjà téléchargés, pour éviter que
# chacun des 15+ postes du parc retélécharge indépendamment les mêmes
# paquets depuis cache.nixos.org.
#
# Aucune signature à gérer côté proxy : c'est un cache HTTP transparent, les
# octets servis sont ceux de cache.nixos.org tels quels. Les clients Nix
# vérifient la signature avec la clé publique cache.nixos.org-1, qui est déjà
# incluse par défaut dans nix.settings.trusted-public-keys sur NixOS — rien
# à ajouter côté client pour la confiance, seulement le substituter.
{ ... }:
{
  # services.nginx crée et gère lui-même /var/cache/nginx/nixcache (nom
  # dérivé de la clé "nixcache" ci-dessous) : rien à déclarer à la main.
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    proxyCachePath."nixcache" = {
      enable = true;
      levels = "1:2";
      useTempPath = false;
      keysZoneName = "nixcache";
      keysZoneSize = "100m";
      # Les .nar sont content-addressés et immuables : on peut se permettre
      # une taille et une durée de rétention généreuses. À ajuster selon
      # l'espace disque réel de la machine hôte.
      maxSize = "100g";
      inactive = "90d";
    };

    virtualHosts."_" = {
      default = true;
      locations."/" = {
        proxyPass = "https://cache.nixos.org";
        extraConfig = ''
          proxy_ssl_server_name on;
          proxy_set_header Host cache.nixos.org;

          proxy_cache nixcache;
          proxy_cache_valid 200 302 90d;
          proxy_cache_valid 404 1m;
          proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
          proxy_cache_lock on;

          add_header X-Cache-Status $upstream_cache_status always;
        '';
      };
    };
  };
}
