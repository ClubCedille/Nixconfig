{ lib, ... }: {
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # Requis par ZFS. Chaque poste a son propre pool jamais importé ailleurs
  # simultanément (pas de clustering), donc une valeur fixe partagée suffit ici.
  networking.hostId = lib.mkDefault "8425e349";

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
}
