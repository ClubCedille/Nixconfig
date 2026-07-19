{ lib, ... }: {
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # Requis par ZFS. Chaque poste a son propre pool jamais importé ailleurs
  # simultanément (pas de clustering), donc une valeur fixe partagée suffit ici.
  networking.hostId = lib.mkDefault "8425e349";

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  # TEMPORAIRE - pour diagnostiquer un échec d'import du pool root en initrd
  # (le compte root de l'initrd est distinct de celui du système principal et
  # est verrouillé par défaut, donc sulogin refuse tout accès sans ça).
  # À retirer ou remplacer par un hash de mot de passe une fois le problème résolu.
  boot.initrd.systemd.emergencyAccess = true;
}
