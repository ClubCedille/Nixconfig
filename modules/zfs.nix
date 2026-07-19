{ lib, ... }: {
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # Par défaut, l'import ZFS en initrd scanne /dev/disk/by-id, qui dépend de
  # l'identification du DISQUE par udev (numéro de série, etc.) - fragile sur
  # certains disques virtio en VM de test (pas de -partN sans serial= explicite
  # sur le disque), et pas nécessaire ici. by-partuuid est généré directement
  # depuis la table de partition GPT elle-même, donc toujours disponible dès
  # que le disque est partitionné, peu importe le contrôleur/hyperviseur.
  boot.zfs.devNodes = "/dev/disk/by-partuuid";

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
