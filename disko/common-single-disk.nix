# disko/common-single-disk.nix
{
  device ? "/dev/stderr",
  ...
}:
{
  disko.devices = {
    disk = {
      # C'est ce nom "main" que l'argument `--disk main "$TARGET_DISK"` va venir cibler
      main = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "20G";
              content = {
                # Note : disko-install formate ce swap (mkswap) mais ne l'active PAS
                # pendant l'installation (DISKO_SKIP_SWAP=1, comportement volontaire
                # de disko-install). Il s'active normalement au premier boot du
                # système installé, via la config générée par disko lui-même.
                type = "swap";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        options.ashift = "12";
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          relatime = "on";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
