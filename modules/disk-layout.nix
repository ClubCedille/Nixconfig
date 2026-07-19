# Layout disque pour un poste single-disk : ESP + swap 20G + pool ZFS "zroot".
#
# Pas de disko ici (voir IsoInstaller/pkgs/install-menu.sh) : disko-install
# construit tout le closure dans le store *live* avant de le copier sur la
# cible, ce qui sature/thrash la RAM sur des postes à 8G avec un profil
# desktop complet. Le partitionnement se fait donc à la main dans
# install-menu.sh (parted + zpool/zfs + mkswap), et ce module déclare
# uniquement comment le système installé doit monter ces mêmes partitions/
# labels au boot. Les labels et le nom du pool doivent rester en phase avec
# install-menu.sh.
{ ... }: {
  fileSystems."/" = {
    device = "zroot/root";
    fsType = "zfs";
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
