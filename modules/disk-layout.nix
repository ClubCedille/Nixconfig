# Layout disque pour un poste single-disk : ESP + swap 20G + root ext4.
#
# Pas de disko ici (voir IsoInstaller/pkgs/install-menu.sh) : disko-install
# construit tout le closure dans le store *live* avant de le copier sur la
# cible, ce qui sature/thrash la RAM sur des postes à 8G avec un profil
# desktop complet. Le partitionnement se fait donc à la main dans
# install-menu.sh (parted + mkfs.ext4 + mkswap), et ce module déclare
# uniquement comment le système installé doit monter ces mêmes partitions/
# labels au boot. Les labels doivent rester en phase avec install-menu.sh.
#
# ext4 (pas ZFS) : ZFS causait des échecs répétés d'import du pool root en
# initrd (désynchronisation hostId, dépendance à /dev/disk/by-id) qu'on n'a
# pas réussi à stabiliser de façon fiable sur le parc de postes cible. ext4
# élimine cette classe de problèmes entièrement (pas de hostId, pas
# d'import de pool, montage par label comme l'ESP).
{ ... }: {
  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];
}
