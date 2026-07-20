# Fait pointer les postes du parc vers le pull-through cache local
# (modules/binary-cache-proxy.nix) avant cache.nixos.org, pour éviter que
# 15+ postes retéléchargent indépendamment les mêmes paquets depuis
# l'upstream officiel.
#
# Pas de clé publique à ajouter : le proxy est un simple cache HTTP
# transparent, cache.nixos.org-1 est déjà dans les trusted-public-keys par
# défaut sur NixOS.
{ lib, ... }:
let
  # Adresse du poste lanets-cache (profiles/lanets-cache.nix) sur le LAN.
  binaryCacheProxy = "http://142.137.247.111";
in
{
  nix.settings.substituters = lib.mkBefore [ binaryCacheProxy ];

  # Si le proxy est down, on ne veut pas attendre longtemps avant de
  # basculer sur cache.nixos.org (qui reste dans la liste par défaut).
  nix.extraOptions = ''
    connect-timeout = 2
  '';
}
